import {
  Injectable,
  NotFoundException,
  ConflictException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaService } from '@/core/database/prisma.service';
import { EmailService } from '@/core/email/email.service';
import { CloudinaryService } from '@/core/upload/cloudinary.service';
import { CreateMemberDto } from './dto/create-member.dto';
import { UpdateMemberDto } from './dto/update-member.dto';
import { QueryMemberDto } from './dto/query-member.dto';
import { ImportMembersDto, ImportResultDto } from './dto/import-members.dto';
import { createPaginatedResponse, PaginatedResult } from '@/common/types/pagination.interface';

@Injectable()
export class MembersService {
  constructor(
    private prisma: PrismaService,
    private emailService: EmailService,
    private cloudinaryService: CloudinaryService,
  ) {}

  /**
   * Create a new member
   */
  async create(createDto: CreateMemberDto, organizationId: string) {
    // Check if email already exists (if provided)
    if (createDto.email) {
      const existing = await this.prisma.member.findFirst({
        where: {
          organizationId,
          email: createDto.email,
          deletedAt: null,
        },
      });

      if (existing) {
        throw new ConflictException('Member with this email already exists');
      }
    }

    // If userId provided, verify user belongs to same organization
    if (createDto.userId) {
      const user = await this.prisma.user.findFirst({
        where: {
          id: createDto.userId,
          organizationId,
        },
      });

      if (!user) {
        throw new BadRequestException('User not found or belongs to different organization');
      }

      // Check if user is already linked to another member
      const existingMember = await this.prisma.member.findFirst({
        where: {
          userId: createDto.userId,
          deletedAt: null,
        },
      });

      if (existingMember) {
        throw new ConflictException('User is already linked to another member');
      }
    }

    // Clean phone country code (remove duplicate + signs)
    const cleanPhoneCountryCode = createDto.phoneCountryCode
      ? '+' + createDto.phoneCountryCode.replace(/\+/g, '').trim()
      : createDto.phoneCountryCode;

    // Create member
    const member = await this.prisma.member.create({
      data: {
        organizationId,
        firstName: createDto.firstName,
        lastName: createDto.lastName,
        email: createDto.email,
        phone: createDto.phone,
        phoneCountryCode: cleanPhoneCountryCode,
        dateOfBirth: createDto.dateOfBirth ? new Date(createDto.dateOfBirth) : null,
        gender: createDto.gender,
        address: createDto.address as any,
        photo: createDto.photo,
        membershipStatus: createDto.membershipStatus,
        joinedDate: createDto.joinedDate ? new Date(createDto.joinedDate) : null,
        baptismDate: createDto.baptismDate ? new Date(createDto.baptismDate) : null,
        maritalStatus: createDto.maritalStatus,
        occupation: createDto.occupation,
        customFields: createDto.customFields as any,
        emergencyContact: createDto.emergencyContact as any,
        userId: createDto.userId,
      },
      include: {
        user: {
          select: {
            id: true,
            email: true,
            firstName: true,
            lastName: true,
          },
        },
      },
    });

    return member;
  }

  /**
   * Get all members with filtering and pagination
   */
  async findAll(
    organizationId: string,
    query: QueryMemberDto,
  ): Promise<PaginatedResult<any>> {
    const {
      page = 1,
      limit = 20,
      search,
      gender,
      membershipStatus,
      maritalStatus,
      joinedAfter,
      joinedBefore,
      sortBy = 'createdAt',
      sortOrder = 'desc',
    } = query;

    const where: any = {
      organizationId,
      deletedAt: null,
    };

    // Build search query
    if (search) {
      where.OR = [
        { firstName: { contains: search, mode: 'insensitive' } },
        { lastName: { contains: search, mode: 'insensitive' } },
        { email: { contains: search, mode: 'insensitive' } },
        { phone: { contains: search } },
      ];
    }

    // Apply filters
    if (gender) {
      where.gender = gender;
    }

    if (membershipStatus) {
      where.membershipStatus = membershipStatus;
    }

    if (maritalStatus) {
      where.maritalStatus = maritalStatus;
    }

    if (joinedAfter || joinedBefore) {
      where.joinedDate = {};
      if (joinedAfter) {
        where.joinedDate.gte = new Date(joinedAfter);
      }
      if (joinedBefore) {
        where.joinedDate.lte = new Date(joinedBefore);
      }
    }

    // Get total count
    const total = await this.prisma.member.count({ where });

    // Build orderBy
    const orderBy: any = {};
    orderBy[sortBy] = sortOrder;

    // Get paginated results
    const members = await this.prisma.member.findMany({
      where,
      skip: (page - 1) * limit,
      take: limit,
      orderBy,
      select: {
        id: true,
        firstName: true,
        lastName: true,
        email: true,
        phone: true,
        dateOfBirth: true,
        gender: true,
        photo: true,
        membershipStatus: true,
        joinedDate: true,
        maritalStatus: true,
        occupation: true,
        createdAt: true,
        user: {
          select: {
            id: true,
            email: true,
            role: true,
          },
        },
      },
    });

    return createPaginatedResponse(members, total, page, limit);
  }

  /**
   * Get single member by ID
   */
  async findOne(id: string, organizationId: string) {
    const member = await this.prisma.member.findFirst({
      where: {
        id,
        organizationId,
        deletedAt: null,
      },
      include: {
        user: {
          select: {
            id: true,
            email: true,
            firstName: true,
            lastName: true,
            role: true,
          },
        },
        attendanceRecords: {
          take: 10,
          orderBy: { checkInTime: 'desc' },
          select: {
            id: true,
            serviceType: true,
            serviceDate: true,
            checkInTime: true,
          },
        },
        groupMemberships: {
          where: { isActive: true },
          include: {
            group: {
              select: {
                id: true,
                name: true,
                groupType: true,
              },
            },
          },
        },
      },
    });

    if (!member) {
      throw new NotFoundException('Member not found');
    }

    return member;
  }

  /**
   * Update member details
   */
  async update(id: string, updateDto: UpdateMemberDto, organizationId: string) {
    const member = await this.prisma.member.findFirst({
      where: {
        id,
        organizationId,
        deletedAt: null,
      },
    });

    if (!member) {
      throw new NotFoundException('Member not found');
    }

    // Check email uniqueness (if changing email)
    if (updateDto.email && updateDto.email !== member.email) {
      const existing = await this.prisma.member.findFirst({
        where: {
          organizationId,
          email: updateDto.email,
          deletedAt: null,
          id: { not: id },
        },
      });

      if (existing) {
        throw new ConflictException('Member with this email already exists');
      }
    }

    // If updating userId, verify constraints
    if (updateDto.userId !== undefined) {
      if (updateDto.userId) {
        const user = await this.prisma.user.findFirst({
          where: {
            id: updateDto.userId,
            organizationId,
          },
        });

        if (!user) {
          throw new BadRequestException('User not found or belongs to different organization');
        }

        // Check if user is already linked to another member
        const existingMember = await this.prisma.member.findFirst({
          where: {
            userId: updateDto.userId,
            deletedAt: null,
            id: { not: id },
          },
        });

        if (existingMember) {
          throw new ConflictException('User is already linked to another member');
        }
      }
    }

    // Clean phone country code (remove duplicate + signs)
    const cleanPhoneCountryCode = updateDto.phoneCountryCode
      ? '+' + updateDto.phoneCountryCode.replace(/\+/g, '').trim()
      : updateDto.phoneCountryCode;

    // Update member
    const updated = await this.prisma.member.update({
      where: { id },
      data: {
        firstName: updateDto.firstName,
        lastName: updateDto.lastName,
        email: updateDto.email,
        phone: updateDto.phone,
        phoneCountryCode: cleanPhoneCountryCode,
        dateOfBirth: updateDto.dateOfBirth ? new Date(updateDto.dateOfBirth) : undefined,
        gender: updateDto.gender,
        address: updateDto.address as any,
        photo: updateDto.photo,
        membershipStatus: updateDto.membershipStatus,
        joinedDate: updateDto.joinedDate ? new Date(updateDto.joinedDate) : undefined,
        baptismDate: updateDto.baptismDate ? new Date(updateDto.baptismDate) : undefined,
        maritalStatus: updateDto.maritalStatus,
        occupation: updateDto.occupation,
        customFields: updateDto.customFields as any,
        emergencyContact: updateDto.emergencyContact as any,
        userId: updateDto.userId,
      },
      include: {
        user: {
          select: {
            id: true,
            email: true,
            firstName: true,
            lastName: true,
          },
        },
      },
    });

    return updated;
  }

  /**
   * Get member by user ID (for current user to view their own profile)
   */
  async getMemberByUserId(userId: string, organizationId: string) {
    const member = await this.prisma.member.findFirst({
      where: {
        userId,
        organizationId,
        deletedAt: null,
      },
      include: {
        user: {
          select: {
            id: true,
            email: true,
            firstName: true,
            lastName: true,
            role: true,
          },
        },
      },
    });

    if (!member) {
      throw new NotFoundException('Member profile not found');
    }

    return member;
  }

  /**
   * Update member by user ID (for current user to update their own profile)
   */
  async updateMemberByUserId(
    userId: string,
    updateDto: UpdateMemberDto,
    organizationId: string,
  ) {
    const member = await this.prisma.member.findFirst({
      where: {
        userId,
        organizationId,
        deletedAt: null,
      },
    });

    if (!member) {
      throw new NotFoundException('Member profile not found');
    }

    // Members cannot change their own userId or membershipStatus
    // These are admin-controlled fields
    const { userId: _, membershipStatus: __, ...allowedFields } = updateDto;

    // Upload photo to Cloudinary if photoBase64 is provided
    let photoUrl = updateDto.photo;
    if (updateDto.photoBase64) {
      try {
        photoUrl = await this.cloudinaryService.uploadBase64(
          updateDto.photoBase64,
          'profile-pictures',
          organizationId,
        );
      } catch (error) {
        console.error('[UPDATE_MEMBER] Failed to upload photo to Cloudinary:', error);
        // Continue with update even if photo upload fails
      }
    }

    // Prepare data for update (exclude photoBase64 from data sent to Prisma)
    const { photoBase64: ____, address, emergencyContact, ...dataToUpdate } = allowedFields;
    if (photoUrl) {
      dataToUpdate.photo = photoUrl;
    }

    // Handle JSON fields properly for Prisma
    const updateData: any = { ...dataToUpdate };
    if (address) {
      updateData.address = address as any;
    }
    if (emergencyContact) {
      updateData.emergencyContact = emergencyContact as any;
    }

    // Convert date strings to Date objects for Prisma
    if (updateData.dateOfBirth && typeof updateData.dateOfBirth === 'string') {
      updateData.dateOfBirth = new Date(updateData.dateOfBirth);
    }
    if (updateData.joinedDate && typeof updateData.joinedDate === 'string') {
      updateData.joinedDate = new Date(updateData.joinedDate);
    }
    if (updateData.baptismDate && typeof updateData.baptismDate === 'string') {
      updateData.baptismDate = new Date(updateData.baptismDate);
    }

    // Clean phone country codes (remove duplicate + signs)
    if (updateData.phoneCountryCode && typeof updateData.phoneCountryCode === 'string') {
      updateData.phoneCountryCode = '+' + updateData.phoneCountryCode.replace(/\+/g, '').trim();
    }

    const updated = await this.prisma.member.update({
      where: { id: member.id },
      data: updateData,
      include: {
        user: {
          select: {
            id: true,
            email: true,
            firstName: true,
            lastName: true,
          },
        },
      },
    });

    return updated;
  }

  /**
   * Soft delete member
   */
  async remove(id: string, organizationId: string) {
    const member = await this.prisma.member.findFirst({
      where: {
        id,
        organizationId,
        deletedAt: null,
      },
    });

    if (!member) {
      throw new NotFoundException('Member not found');
    }

    // Soft delete
    const updated = await this.prisma.member.update({
      where: { id },
      data: { deletedAt: new Date() },
    });

    return { message: 'Member deleted successfully', member: updated };
  }

  /**
   * Restore soft-deleted member
   */
  async restore(id: string, organizationId: string) {
    const member = await this.prisma.member.findFirst({
      where: {
        id,
        organizationId,
      },
    });

    if (!member) {
      throw new NotFoundException('Member not found');
    }

    if (!member.deletedAt) {
      throw new BadRequestException('Member is not deleted');
    }

    // Restore
    const updated = await this.prisma.member.update({
      where: { id },
      data: { deletedAt: null },
    });

    return updated;
  }

  /**
   * Bulk import members
   */
  async importMembers(
    importDto: ImportMembersDto,
    organizationId: string,
  ): Promise<ImportResultDto> {
    const result: ImportResultDto = {
      success: true,
      imported: 0,
      failed: 0,
      errors: [],
    };

    for (let i = 0; i < importDto.members.length; i++) {
      const memberDto = importDto.members[i];

      try {
        await this.create(memberDto, organizationId);
        result.imported++;
      } catch (error) {
        result.failed++;
        result.errors!.push({
          row: i + 1,
          email: memberDto.email,
          name: `${memberDto.firstName} ${memberDto.lastName}`,
          error: error.message,
        });
      }
    }

    result.success = result.failed === 0;

    return result;
  }

  /**
   * Export members to CSV format
   */
  async exportMembers(organizationId: string, query: QueryMemberDto): Promise<string> {
    // Get all members matching query (without pagination)
    const where: any = {
      organizationId,
      deletedAt: null,
    };

    // Apply same filters as findAll
    if (query.search) {
      where.OR = [
        { firstName: { contains: query.search, mode: 'insensitive' } },
        { lastName: { contains: query.search, mode: 'insensitive' } },
        { email: { contains: query.search, mode: 'insensitive' } },
      ];
    }

    if (query.gender) where.gender = query.gender;
    if (query.membershipStatus) where.membershipStatus = query.membershipStatus;
    if (query.maritalStatus) where.maritalStatus = query.maritalStatus;

    const members = await this.prisma.member.findMany({
      where,
      orderBy: { createdAt: 'desc' },
    });

    // Generate CSV
    const headers = [
      'First Name',
      'Last Name',
      'Email',
      'Phone',
      'Date of Birth',
      'Gender',
      'Membership Status',
      'Joined Date',
      'Baptism Date',
      'Marital Status',
      'Occupation',
    ];

    const rows = members.map((m) => [
      m.firstName,
      m.lastName,
      m.email || '',
      m.phone || '',
      m.dateOfBirth ? m.dateOfBirth.toISOString().split('T')[0] : '',
      m.gender || '',
      m.membershipStatus,
      m.joinedDate ? m.joinedDate.toISOString().split('T')[0] : '',
      m.baptismDate ? m.baptismDate.toISOString().split('T')[0] : '',
      m.maritalStatus || '',
      m.occupation || '',
    ]);

    const csv = [headers, ...rows].map((row) => row.join(',')).join('\n');

    return csv;
  }

  /**
   * Get member statistics
   */
  async getStats(organizationId: string) {
    const [
      totalMembers,
      activeMembers,
      visitors,
      newMembers,
      recentBaptisms,
      genderStats,
      ageGroupStats,
    ] = await Promise.all([
      // Total members
      this.prisma.member.count({
        where: { organizationId, deletedAt: null },
      }),

      // Active members
      this.prisma.member.count({
        where: {
          organizationId,
          deletedAt: null,
          membershipStatus: 'ACTIVE_MEMBER',
        },
      }),

      // Visitors
      this.prisma.member.count({
        where: {
          organizationId,
          deletedAt: null,
          membershipStatus: 'VISITOR',
        },
      }),

      // New members (joined in last 30 days)
      this.prisma.member.count({
        where: {
          organizationId,
          deletedAt: null,
          joinedDate: {
            gte: new Date(new Date().setDate(new Date().getDate() - 30)),
          },
        },
      }),

      // Recent baptisms (last 90 days)
      this.prisma.member.count({
        where: {
          organizationId,
          deletedAt: null,
          baptismDate: {
            gte: new Date(new Date().setDate(new Date().getDate() - 90)),
          },
        },
      }),

      // Gender distribution
      this.prisma.member.groupBy({
        by: ['gender'],
        where: { organizationId, deletedAt: null },
        _count: true,
      }),

      // Age group distribution (simplified)
      this.prisma.member.findMany({
        where: {
          organizationId,
          deletedAt: null,
          dateOfBirth: { not: null },
        },
        select: { dateOfBirth: true },
      }),
    ]);

    // Calculate age groups
    const ageGroups = {
      '0-12': 0,
      '13-18': 0,
      '19-25': 0,
      '26-40': 0,
      '41-60': 0,
      '60+': 0,
    };

    ageGroupStats.forEach((member) => {
      if (member.dateOfBirth) {
        const age = Math.floor(
          (new Date().getTime() - new Date(member.dateOfBirth).getTime()) / 31557600000,
        );
        if (age <= 12) ageGroups['0-12']++;
        else if (age <= 18) ageGroups['13-18']++;
        else if (age <= 25) ageGroups['19-25']++;
        else if (age <= 40) ageGroups['26-40']++;
        else if (age <= 60) ageGroups['41-60']++;
        else ageGroups['60+']++;
      }
    });

    return {
      totalMembers,
      activeMembers,
      visitors,
      newMembers,
      recentBaptisms,
      genderDistribution: genderStats.reduce((acc, stat) => {
        acc[stat.gender || 'Unknown'] = stat._count;
        return acc;
      }, {}),
      ageDistribution: ageGroups,
    };
  }

  /**
   * Send invite to member for app signup
   */
  async sendInvite(
    memberId: string,
    sendInviteDto: any,
    organizationId: string,
  ) {
    // Find member and validate
    const member = await this.prisma.member.findFirst({
      where: { id: memberId, organizationId, deletedAt: null },
      include: { organization: true },
    });

    if (!member) {
      throw new NotFoundException('Member not found');
    }

    if (member.userId) {
      throw new BadRequestException('Member already has an active account');
    }

    if (!member.phone && !member.email) {
      throw new BadRequestException('Member must have phone or email to receive invite');
    }

    // Generate invite token (32 char random string)
    const token = this.generateRandomToken(32);

    // Generate human-readable invite code (6 digit alphanumeric)
    const inviteCode = this.generateInviteCode();

    // Set expiration to 7 days from now
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7);

    // Create invite token record
    await this.prisma.inviteToken.create({
      data: {
        memberId,
        organizationId,
        token,
        inviteCode,
        expiresAt,
        sentVia: sendInviteDto.method,
      },
    });

    // Update member status
    await this.prisma.member.update({
      where: { id: memberId },
      data: {
        inviteStatus: 'INVITED',
        invitedAt: new Date(),
      },
    });

    // Generate invite URL
    const inviteUrl = `https://shepherdsync.app/invite/${token}`;

    // Send invite via selected method
    await this.sendInviteNotification(
      member,
      sendInviteDto.method,
      inviteUrl,
      inviteCode,
      expiresAt,
      sendInviteDto.customMessage,
    );

    return {
      success: true,
      message: `Invite sent via ${sendInviteDto.method}`,
      inviteToken: token,
      inviteCode,
      inviteUrl,
      expiresAt,
      sentVia: sendInviteDto.method,
    };
  }

  /**
   * Resend expired or failed invite
   */
  async resendInvite(
    memberId: string,
    sendInviteDto: any,
    organizationId: string,
  ) {
    // Invalidate old tokens
    await this.prisma.inviteToken.updateMany({
      where: { memberId, isValid: true },
      data: { isValid: false },
    });

    // Send new invite
    return this.sendInvite(memberId, sendInviteDto, organizationId);
  }

  /**
   * Generate random secure token
   */
  private generateRandomToken(length: number): string {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let token = '';
    for (let i = 0; i < length; i++) {
      token += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return token;
  }

  /**
   * Generate human-readable 6-digit invite code
   */
  private generateInviteCode(): string {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    let code = '';
    for (let i = 0; i < 6; i++) {
      code += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return code;
  }

  /**
   * Send invite notification via selected method
   */
  private async sendInviteNotification(
    member: any,
    method: string,
    inviteUrl: string,
    inviteCode: string,
    expiresAt: Date,
    customMessage?: string,
  ) {
    const churchName = member.organization.name;
    const memberName = member.firstName;

    const defaultMessage = `${memberName}, you've been invited to join ${churchName} on Shepherd Sync! Tap the link to complete your profile and get started.`;
    const message = customMessage || defaultMessage;

    // Format expiration date
    const formattedExpirationDate = expiresAt.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    });

    switch (method) {
      case 'SMS':
        if (member.phone) {
          // TODO: Integrate with SMS service (Twilio)
          console.log(`[SMS] To: ${member.phone}`);
          console.log(`[SMS] Message: ${message}`);
          console.log(`[SMS] Link: ${inviteUrl}`);
          console.log(`[SMS] Code: ${inviteCode}`);
          // await this.smsService.send(member.phone, `${message}\n\n${inviteUrl}\n\nOr use code: ${inviteCode}`);
        }
        break;

      case 'EMAIL':
        if (member.email) {
          await this.emailService.sendMemberInviteEmail({
            to: member.email,
            memberFirstName: memberName,
            churchName,
            inviteUrl,
            inviteCode,
            expirationDate: formattedExpirationDate,
            churchLogoUrl: member.organization.logoUrl,
          });
        }
        break;

      case 'WHATSAPP':
        if (member.phone) {
          // TODO: Integrate with WhatsApp Business API
          console.log(`[WHATSAPP] To: ${member.phone}`);
          console.log(`[WHATSAPP] Message: ${message}`);
          console.log(`[WHATSAPP] Link: ${inviteUrl}`);
          console.log(`[WHATSAPP] Code: ${inviteCode}`);
          // await this.whatsappService.send(member.phone, `${message}\n\n${inviteUrl}\n\nOr use code: ${inviteCode}`);
        }
        break;

      case 'MANUAL':
        // Admin will copy and share manually
        console.log(`[MANUAL] Invite ready to be shared manually`);
        console.log(`[MANUAL] URL: ${inviteUrl}`);
        console.log(`[MANUAL] Code: ${inviteCode}`);
        break;
    }
  }
}
