import { Injectable, NotFoundException, ConflictException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '@/core/database/prisma.service';
import { CreateOrganizationDto } from './dto/create-organization.dto';
import { UpdateOrganizationDto } from './dto/update-organization.dto';
import { QueryOrganizationDto } from './dto/query-organization.dto';
import { UpdateOrganizationSettingsDto } from './dto/update-settings.dto';
import { createPaginatedResponse, PaginatedResult } from '@/common/types/pagination.interface';
import { PlanType, SubscriptionStatus, UserRole } from '@prisma/client';

@Injectable()
export class OrganizationsService {
  constructor(private prisma: PrismaService) {}

  /**
   * Create a new organization
   * Only SUPER_ADMIN can create organizations via this endpoint
   * Regular signups use auth/register
   */
  async create(createDto: CreateOrganizationDto) {
    // Check if subdomain already exists
    const existing = await this.prisma.organization.findUnique({
      where: { subdomain: createDto.subdomain.toLowerCase() },
    });

    if (existing) {
      throw new ConflictException(`Subdomain '${createDto.subdomain}' is already taken`);
    }

    // Create organization with trial period
    const trialDays = parseInt(process.env.TRIAL_PERIOD_DAYS || '14', 10);
    const trialEndsAt = new Date();
    trialEndsAt.setDate(trialEndsAt.getDate() + trialDays);

    const organization = await this.prisma.organization.create({
      data: {
        name: createDto.name,
        subdomain: createDto.subdomain.toLowerCase(),
        timezone: createDto.timezone || 'America/New_York',
        currency: createDto.currency || 'USD',
        logo: createDto.logo,
        planType: PlanType.TRIAL,
        subscriptionStatus: SubscriptionStatus.TRIALING,
        trialEndsAt,
        isActive: true,
      },
    });

    return organization;
  }

  /**
   * Get all organizations (SUPER_ADMIN only)
   * With pagination and filtering
   */
  async findAll(query: QueryOrganizationDto): Promise<PaginatedResult<any>> {
    const { page = 1, limit = 20, search, planType, subscriptionStatus, isActive } = query;

    const where: any = {};

    // Build where clause
    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { subdomain: { contains: search, mode: 'insensitive' } },
      ];
    }

    if (planType) {
      where.planType = planType;
    }

    if (subscriptionStatus) {
      where.subscriptionStatus = subscriptionStatus;
    }

    if (isActive !== undefined) {
      where.isActive = isActive;
    }

    // Get total count
    const total = await this.prisma.organization.count({ where });

    // Get paginated results
    const organizations = await this.prisma.organization.findMany({
      where,
      skip: (page - 1) * limit,
      take: limit,
      orderBy: { createdAt: 'desc' },
      select: {
        id: true,
        name: true,
        subdomain: true,
        logo: true,
        planType: true,
        subscriptionStatus: true,
        trialEndsAt: true,
        isActive: true,
        timezone: true,
        currency: true,
        createdAt: true,
        _count: {
          select: {
            users: true,
            members: true,
            events: true,
          },
        },
      },
    });

    return createPaginatedResponse(organizations, total, page, limit);
  }

  /**
   * Get single organization by ID
   * SUPER_ADMIN: can access any organization
   * Others: can only access their own organization
   */
  async findOne(id: string, userRole: UserRole, userOrgId: string) {
    // Only super admins can access other organizations
    if (userRole !== UserRole.SUPER_ADMIN && id !== userOrgId) {
      throw new ForbiddenException('You can only access your own organization');
    }

    const organization = await this.prisma.organization.findUnique({
      where: { id },
      include: {
        _count: {
          select: {
            users: true,
            members: true,
            events: true,
            donations: true,
            groups: true,
          },
        },
      },
    });

    if (!organization) {
      throw new NotFoundException('Organization not found');
    }

    return organization;
  }

  /**
   * Update organization details
   * Only organization admins or super admins can update
   */
  async update(id: string, updateDto: UpdateOrganizationDto, userRole: UserRole, userOrgId: string) {
    // Only super admins can update other organizations
    if (userRole !== UserRole.SUPER_ADMIN && id !== userOrgId) {
      throw new ForbiddenException('You can only update your own organization');
    }

    // Check if organization exists
    const existing = await this.prisma.organization.findUnique({
      where: { id },
    });

    if (!existing) {
      throw new NotFoundException('Organization not found');
    }

    // Update organization
    const updated = await this.prisma.organization.update({
      where: { id },
      data: updateDto,
    });

    return updated;
  }

  /**
   * Update organization settings (branding, preferences)
   */
  async updateSettings(
    id: string,
    settingsDto: UpdateOrganizationSettingsDto,
    userRole: UserRole,
    userOrgId: string,
  ) {
    // Only super admins can update other organizations
    if (userRole !== UserRole.SUPER_ADMIN && id !== userOrgId) {
      throw new ForbiddenException('You can only update your own organization');
    }

    const organization = await this.prisma.organization.findUnique({
      where: { id },
    });

    if (!organization) {
      throw new NotFoundException('Organization not found');
    }

    // Check if PREMIUM plan for custom branding
    if ((settingsDto.customDomain || settingsDto.primaryColor || settingsDto.secondaryColor) &&
        organization.planType !== PlanType.PREMIUM) {
      throw new ForbiddenException('Custom branding requires PREMIUM plan');
    }

    const updated = await this.prisma.organization.update({
      where: { id },
      data: {
        customDomain: settingsDto.customDomain,
        primaryColor: settingsDto.primaryColor,
        secondaryColor: settingsDto.secondaryColor,
        settings: settingsDto.settings,
      },
    });

    return updated;
  }

  /**
   * Get organization statistics
   */
  async getStats(organizationId: string, userRole: UserRole, userOrgId: string) {
    // Only super admins can access other organizations
    if (userRole !== UserRole.SUPER_ADMIN && organizationId !== userOrgId) {
      throw new ForbiddenException('You can only access your own organization stats');
    }

    const [
      totalUsers,
      totalMembers,
      totalEvents,
      totalDonations,
      totalGroups,
      recentDonations,
      upcomingEvents,
    ] = await Promise.all([
      this.prisma.user.count({ where: { organizationId } }),
      this.prisma.member.count({ where: { organizationId, deletedAt: null } }),
      this.prisma.event.count({ where: { organizationId } }),
      this.prisma.donation.count({ where: { organizationId } }),
      this.prisma.group.count({ where: { organizationId } }),
      this.prisma.donation.aggregate({
        where: {
          organizationId,
          createdAt: {
            gte: new Date(new Date().setDate(new Date().getDate() - 30)),
          },
        },
        _sum: { amount: true },
      }),
      this.prisma.event.count({
        where: {
          organizationId,
          startDate: { gte: new Date() },
        },
      }),
    ]);

    return {
      users: totalUsers,
      members: totalMembers,
      events: totalEvents,
      donations: totalDonations,
      groups: totalGroups,
      recentDonationsTotal: recentDonations._sum.amount || 0,
      upcomingEvents,
    };
  }

  /**
   * Soft delete organization (SUPER_ADMIN only)
   */
  async remove(id: string) {
    const organization = await this.prisma.organization.findUnique({
      where: { id },
    });

    if (!organization) {
      throw new NotFoundException('Organization not found');
    }

    // Deactivate instead of hard delete
    const updated = await this.prisma.organization.update({
      where: { id },
      data: { isActive: false },
    });

    return updated;
  }
}
