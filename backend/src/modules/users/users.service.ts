import {
  Injectable,
  NotFoundException,
  ConflictException,
  ForbiddenException,
  BadRequestException,
  UnauthorizedException,
} from '@nestjs/common';
import { PrismaService } from '@/core/database/prisma.service';
import { EmailService } from '@/core/email/email.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { QueryUserDto } from './dto/query-user.dto';
import { InviteUserDto } from './dto/invite-user.dto';
import { ChangePasswordDto } from './dto/change-password.dto';
import { RequestPasswordResetDto, ResetPasswordDto } from './dto/reset-password.dto';
import { createPaginatedResponse, PaginatedResult } from '@/common/types/pagination.interface';
import { UserRole } from '@prisma/client';
import * as bcrypt from 'bcrypt';
import { randomBytes } from 'crypto';

@Injectable()
export class UsersService {
  constructor(
    private prisma: PrismaService,
    private emailService: EmailService,
  ) {}

  /**
   * Create a new user
   * Admins can create users within their organization
   */
  async create(createDto: CreateUserDto, organizationId: string, creatorRole: UserRole) {
    // Prevent creating SUPER_ADMIN users
    if (createDto.role === UserRole.SUPER_ADMIN && creatorRole !== UserRole.SUPER_ADMIN) {
      throw new ForbiddenException('Cannot create SUPER_ADMIN users');
    }

    // Check if email already exists
    const existing = await this.prisma.user.findUnique({
      where: { email: createDto.email },
    });

    if (existing) {
      throw new ConflictException('Email already registered');
    }

    // Hash password if provided
    let passwordHash: string | undefined;
    if (createDto.password) {
      passwordHash = await bcrypt.hash(createDto.password, 10);
    }

    // Create user
    const user = await this.prisma.user.create({
      data: {
        organizationId,
        email: createDto.email,
        passwordHash,
        firstName: createDto.firstName,
        lastName: createDto.lastName,
        phone: createDto.phone,
        avatar: createDto.avatar,
        role: createDto.role,
        isActive: true,
        emailVerified: false,
      },
      select: {
        id: true,
        email: true,
        firstName: true,
        lastName: true,
        phone: true,
        avatar: true,
        role: true,
        isActive: true,
        emailVerified: true,
        createdAt: true,
      },
    });

    // If no password provided, send invitation email
    if (!createDto.password) {
      // Generate temporary token for invitation
      const invitationToken = randomBytes(32).toString('hex');
      const tokenExpiry = new Date();
      tokenExpiry.setHours(tokenExpiry.getHours() + 48); // 48 hours expiry

      await this.prisma.user.update({
        where: { id: user.id },
        data: {
          resetToken: invitationToken,
          resetTokenExpiry: tokenExpiry,
        },
      });

      // Send invitation email
      try {
        await this.emailService.sendTransactional(user.email, 'user-invitation', {
          firstName: user.firstName,
          invitationLink: `${process.env.FRONTEND_URL}/accept-invitation?token=${invitationToken}`,
        });
      } catch (error) {
        console.error('Failed to send invitation email:', error);
      }
    }

    return user;
  }

  /**
   * Send invitation to a new user
   * Creates user account and sends invitation email
   */
  async inviteUser(inviteDto: InviteUserDto, organizationId: string, creatorRole: UserRole) {
    // Prevent inviting SUPER_ADMIN users
    if (inviteDto.role === UserRole.SUPER_ADMIN && creatorRole !== UserRole.SUPER_ADMIN) {
      throw new ForbiddenException('Cannot invite SUPER_ADMIN users');
    }

    // Check if email already exists
    const existing = await this.prisma.user.findUnique({
      where: { email: inviteDto.email },
    });

    if (existing) {
      throw new ConflictException('User with this email already exists');
    }

    // Generate invitation token
    const invitationToken = randomBytes(32).toString('hex');
    const tokenExpiry = new Date();
    tokenExpiry.setHours(tokenExpiry.getHours() + 48); // 48 hours expiry

    // Create user without password
    const user = await this.prisma.user.create({
      data: {
        organizationId,
        email: inviteDto.email,
        firstName: inviteDto.firstName,
        lastName: inviteDto.lastName,
        role: inviteDto.role,
        isActive: true,
        emailVerified: false,
        resetToken: invitationToken,
        resetTokenExpiry: tokenExpiry,
      },
      select: {
        id: true,
        email: true,
        firstName: true,
        lastName: true,
        role: true,
      },
    });

    // Send invitation email
    try {
      await this.emailService.sendTransactional(user.email, 'user-invitation', {
        firstName: user.firstName,
        invitationLink: `${process.env.FRONTEND_URL}/accept-invitation?token=${invitationToken}`,
        customMessage: inviteDto.customMessage,
      });
    } catch (error) {
      console.error('Failed to send invitation email:', error);
      // Don't throw - user is created, can resend invitation later
    }

    return {
      user,
      message: 'Invitation sent successfully',
    };
  }

  /**
   * Get all users in organization with filtering and pagination
   */
  async findAll(
    organizationId: string,
    query: QueryUserDto,
  ): Promise<PaginatedResult<any>> {
    const { page = 1, limit = 20, search, role, isActive, emailVerified } = query;

    const where: any = { organizationId };

    // Build where clause
    if (search) {
      where.OR = [
        { firstName: { contains: search, mode: 'insensitive' } },
        { lastName: { contains: search, mode: 'insensitive' } },
        { email: { contains: search, mode: 'insensitive' } },
      ];
    }

    if (role) {
      where.role = role;
    }

    if (isActive !== undefined) {
      where.isActive = isActive;
    }

    if (emailVerified !== undefined) {
      where.emailVerified = emailVerified;
    }

    // Get total count
    const total = await this.prisma.user.count({ where });

    // Get paginated results
    const users = await this.prisma.user.findMany({
      where,
      skip: (page - 1) * limit,
      take: limit,
      orderBy: { createdAt: 'desc' },
      select: {
        id: true,
        email: true,
        firstName: true,
        lastName: true,
        phone: true,
        avatar: true,
        role: true,
        isActive: true,
        emailVerified: true,
        lastLoginAt: true,
        loginCount: true,
        createdAt: true,
      },
    });

    return createPaginatedResponse(users, total, page, limit);
  }

  /**
   * Get single user by ID
   */
  async findOne(id: string, organizationId: string, userRole: UserRole, userId: string) {
    const user = await this.prisma.user.findFirst({
      where: {
        id,
        organizationId,
      },
      select: {
        id: true,
        email: true,
        firstName: true,
        lastName: true,
        phone: true,
        avatar: true,
        role: true,
        isActive: true,
        emailVerified: true,
        lastLoginAt: true,
        loginCount: true,
        createdAt: true,
        updatedAt: true,
      },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Users can view their own profile
    // Admins can view any user in their organization
    if (user.id !== userId && userRole !== UserRole.ADMIN && userRole !== UserRole.SUPER_ADMIN) {
      throw new ForbiddenException('You can only view your own profile');
    }

    return user;
  }

  /**
   * Update user details
   */
  async update(
    id: string,
    updateDto: UpdateUserDto,
    organizationId: string,
    userRole: UserRole,
    userId: string,
  ) {
    const user = await this.prisma.user.findFirst({
      where: {
        id,
        organizationId,
      },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Only admins can update other users
    // Only admins can change roles
    if (user.id !== userId && userRole !== UserRole.ADMIN && userRole !== UserRole.SUPER_ADMIN) {
      throw new ForbiddenException('You can only update your own profile');
    }

    // Only admins can change roles
    if (updateDto.role && userRole !== UserRole.ADMIN && userRole !== UserRole.SUPER_ADMIN) {
      throw new ForbiddenException('Only admins can change user roles');
    }

    // Prevent non-super-admins from creating super admins
    if (updateDto.role === UserRole.SUPER_ADMIN && userRole !== UserRole.SUPER_ADMIN) {
      throw new ForbiddenException('Cannot assign SUPER_ADMIN role');
    }

    // Update user
    const updated = await this.prisma.user.update({
      where: { id },
      data: updateDto,
      select: {
        id: true,
        email: true,
        firstName: true,
        lastName: true,
        phone: true,
        avatar: true,
        role: true,
        isActive: true,
        emailVerified: true,
        updatedAt: true,
      },
    });

    return updated;
  }

  /**
   * Change user password
   */
  async changePassword(userId: string, changePasswordDto: ChangePasswordDto) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Verify current password
    if (!user.passwordHash) {
      throw new BadRequestException('No password set for this user');
    }

    const isPasswordValid = await bcrypt.compare(
      changePasswordDto.currentPassword,
      user.passwordHash,
    );

    if (!isPasswordValid) {
      throw new UnauthorizedException('Current password is incorrect');
    }

    // Hash new password
    const newPasswordHash = await bcrypt.hash(changePasswordDto.newPassword, 10);

    // Update password
    await this.prisma.user.update({
      where: { id: userId },
      data: { passwordHash: newPasswordHash },
    });

    return { message: 'Password changed successfully' };
  }

  /**
   * Request password reset
   * Sends email with reset token
   */
  async requestPasswordReset(requestDto: RequestPasswordResetDto) {
    const user = await this.prisma.user.findUnique({
      where: { email: requestDto.email },
    });

    // Don't reveal if email exists
    if (!user) {
      return { message: 'If the email exists, a reset link has been sent' };
    }

    // Generate reset token
    const resetToken = randomBytes(32).toString('hex');
    const tokenExpiry = new Date();
    tokenExpiry.setHours(tokenExpiry.getHours() + 1); // 1 hour expiry

    // Save token
    await this.prisma.user.update({
      where: { id: user.id },
      data: {
        resetToken,
        resetTokenExpiry: tokenExpiry,
      },
    });

    // Send reset email
    try {
      await this.emailService.sendTransactional(user.email, 'password-reset', {
        firstName: user.firstName,
        resetLink: `${process.env.FRONTEND_URL}/reset-password?token=${resetToken}`,
      });
    } catch (error) {
      console.error('Failed to send password reset email:', error);
    }

    return { message: 'If the email exists, a reset link has been sent' };
  }

  /**
   * Reset password with token
   */
  async resetPassword(resetDto: ResetPasswordDto) {
    const user = await this.prisma.user.findFirst({
      where: {
        resetToken: resetDto.token,
        resetTokenExpiry: {
          gte: new Date(),
        },
      },
    });

    if (!user) {
      throw new BadRequestException('Invalid or expired reset token');
    }

    // Hash new password
    const passwordHash = await bcrypt.hash(resetDto.newPassword, 10);

    // Update password and clear reset token
    await this.prisma.user.update({
      where: { id: user.id },
      data: {
        passwordHash,
        resetToken: null,
        resetTokenExpiry: null,
        emailVerified: true, // Verify email when resetting password
      },
    });

    return { message: 'Password reset successfully' };
  }

  /**
   * Verify email address
   */
  async verifyEmail(token: string) {
    const user = await this.prisma.user.findFirst({
      where: {
        resetToken: token,
        resetTokenExpiry: {
          gte: new Date(),
        },
      },
    });

    if (!user) {
      throw new BadRequestException('Invalid or expired verification token');
    }

    // Mark email as verified
    await this.prisma.user.update({
      where: { id: user.id },
      data: {
        emailVerified: true,
        resetToken: null,
        resetTokenExpiry: null,
      },
    });

    return { message: 'Email verified successfully' };
  }

  /**
   * Resend invitation email
   */
  async resendInvitation(userId: string, organizationId: string) {
    const user = await this.prisma.user.findFirst({
      where: {
        id: userId,
        organizationId,
      },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    if (user.emailVerified && user.passwordHash) {
      throw new BadRequestException('User has already accepted invitation');
    }

    // Generate new invitation token
    const invitationToken = randomBytes(32).toString('hex');
    const tokenExpiry = new Date();
    tokenExpiry.setHours(tokenExpiry.getHours() + 48); // 48 hours expiry

    await this.prisma.user.update({
      where: { id: user.id },
      data: {
        resetToken: invitationToken,
        resetTokenExpiry: tokenExpiry,
      },
    });

    // Send invitation email
    await this.emailService.sendTransactional(user.email, 'user-invitation', {
      firstName: user.firstName,
      invitationLink: `${process.env.FRONTEND_URL}/accept-invitation?token=${invitationToken}`,
    });

    return { message: 'Invitation resent successfully' };
  }

  /**
   * Deactivate user (soft delete)
   */
  async remove(id: string, organizationId: string, userRole: UserRole) {
    const user = await this.prisma.user.findFirst({
      where: {
        id,
        organizationId,
      },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Prevent deleting super admins
    if (user.role === UserRole.SUPER_ADMIN && userRole !== UserRole.SUPER_ADMIN) {
      throw new ForbiddenException('Cannot deactivate SUPER_ADMIN users');
    }

    // Deactivate user
    const updated = await this.prisma.user.update({
      where: { id },
      data: { isActive: false },
    });

    return updated;
  }

  /**
   * Reactivate user
   */
  async reactivate(id: string, organizationId: string) {
    const user = await this.prisma.user.findFirst({
      where: {
        id,
        organizationId,
      },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Reactivate user
    const updated = await this.prisma.user.update({
      where: { id },
      data: { isActive: true },
    });

    return updated;
  }
}
