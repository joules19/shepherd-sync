import {
  Injectable,
  UnauthorizedException,
  ConflictException,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '@/core/database/prisma.service';
import { CloudinaryService } from '@/core/upload/cloudinary.service';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import { CompleteInviteDto } from '@/modules/members/dto/complete-invite.dto';
import * as bcrypt from 'bcrypt';
import { UserRole, PlanType, SubscriptionStatus } from '@prisma/client';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private configService: ConfigService,
    private cloudinaryService: CloudinaryService,
  ) { }

  async register(registerDto: RegisterDto) {
    // Check if email already exists
    const existingUser = await this.prisma.user.findUnique({
      where: { email: registerDto.email },
    });

    if (existingUser) {
      throw new ConflictException('Email already registered');
    }

    // Check if subdomain already exists
    const existingOrg = await this.prisma.organization.findUnique({
      where: { subdomain: registerDto.subdomain.toLowerCase() },
    });

    if (existingOrg) {
      throw new ConflictException('Subdomain already taken');
    }

    // Hash password
    const passwordHash = await bcrypt.hash(registerDto.password, 10);

    // Calculate trial end date
    const trialDays = parseInt(this.configService.get('TRIAL_PERIOD_DAYS', '14'), 10);
    const trialEndsAt = new Date();
    trialEndsAt.setDate(trialEndsAt.getDate() + trialDays);

    // Create organization and admin user in a transaction
    const result = await this.prisma.$transaction(async (tx) => {
      // Create organization
      const organization = await tx.organization.create({
        data: {
          name: registerDto.organizationName,
          subdomain: registerDto.subdomain.toLowerCase(),
          planType: PlanType.TRIAL,
          subscriptionStatus: SubscriptionStatus.TRIALING,
          trialEndsAt,
          isActive: true,
        },
      });

      // Create admin user
      const user = await tx.user.create({
        data: {
          organizationId: organization.id,
          email: registerDto.email,
          passwordHash,
          firstName: registerDto.firstName,
          lastName: registerDto.lastName,
          phone: registerDto.phone,
          role: UserRole.ADMIN,
          emailVerified: false,
          isActive: true,
        },
        select: {
          id: true,
          email: true,
          firstName: true,
          lastName: true,
          role: true,
          organizationId: true,
          avatar: true,
          phone: true,
          phoneCountryCode: true,
        },
      });

      return { organization, user };
    });

    // Generate tokens
    const tokens = await this.generateTokens(result.user);

    return {
      user: result.user,
      organization: {
        id: result.organization.id,
        name: result.organization.name,
        subdomain: result.organization.subdomain,
        planType: result.organization.planType,
        trialEndsAt: result.organization.trialEndsAt,
      },
      ...tokens,
    };
  }

  async login(loginDto: LoginDto) {
    // Find user
    const user = await this.prisma.user.findUnique({
      where: { email: loginDto.email },
      include: {
        organization: {
          select: {
            id: true,
            name: true,
            subdomain: true,
            planType: true,
            isActive: true,
            subscriptionStatus: true,
          },
        },
      },
    });

    console.log('[LOGIN] User from DB:', {
      id: user?.id,
      email: user?.email,
      avatar: user?.avatar,
      phone: user?.phone,
      phoneCountryCode: user?.phoneCountryCode,
    });

    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }

    // Check if user is active
    if (!user.isActive) {
      throw new UnauthorizedException('Account is inactive');
    }

    // Check if organization is active
    if (!user.organization.isActive) {
      throw new UnauthorizedException('Organization subscription is inactive');
    }

    // Check if password hash exists
    if (!user.passwordHash) {
      throw new UnauthorizedException('Please complete your account setup via invitation link');
    }

    // Verify password
    const isPasswordValid = await bcrypt.compare(loginDto.password, user.passwordHash);

    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    // Update last login
    await this.prisma.user.update({
      where: { id: user.id },
      data: {
        lastLoginAt: new Date(),
        loginCount: { increment: 1 },
      },
    });

    // Generate tokens
    const tokens = await this.generateTokens({
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      role: user.role,
      organizationId: user.organizationId,
    });

    const response = {
      user: {
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role,
        organizationId: user.organizationId,
        avatar: user.avatar,
        phone: user.phone,
        phoneCountryCode: user.phoneCountryCode,
      },
      organization: user.organization,
      ...tokens,
    };

    console.log('[LOGIN] Returning user with avatar:', user.avatar ? 'YES' : 'NO');
    console.log('[LOGIN] Avatar URL:', user.avatar);

    return response;
  }

  async refreshToken(refreshToken: string) {
    try {
      const payload = this.jwtService.verify(refreshToken, {
        secret: this.configService.get('JWT_REFRESH_SECRET'),
      });

      const user = await this.prisma.user.findUnique({
        where: { id: payload.sub },
        select: {
          id: true,
          email: true,
          firstName: true,
          lastName: true,
          role: true,
          organizationId: true,
          isActive: true,
        },
      });

      if (!user || !user.isActive) {
        throw new UnauthorizedException('User not found or inactive');
      }

      return this.generateTokens(user);
    } catch (error) {
      throw new UnauthorizedException('Invalid refresh token');
    }
  }

  private async generateTokens(user: {
    id: string;
    email: string;
    firstName: string;
    lastName: string;
    role: UserRole;
    organizationId: string;
  }) {
    const payload = {
      sub: user.id,
      email: user.email,
      role: user.role,
      organizationId: user.organizationId,
    };

    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(payload, {
        secret: this.configService.get('JWT_SECRET'),
        expiresIn: this.configService.get('JWT_EXPIRATION', '7d'),
      }),
      this.jwtService.signAsync(payload, {
        secret: this.configService.get('JWT_REFRESH_SECRET'),
        expiresIn: this.configService.get('JWT_REFRESH_EXPIRATION', '30d'),
      }),
    ]);

    return {
      accessToken,
      refreshToken,
    };
  }

  async validateUser(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        email: true,
        firstName: true,
        lastName: true,
        role: true,
        organizationId: true,
        avatar: true,
        phone: true,
        phoneCountryCode: true,
        isActive: true,
        organization: {
          select: {
            id: true,
            name: true,
            subdomain: true,
            planType: true,
            logo: true,
            isActive: true,
            subscriptionStatus: true,
          },
        },
      },
    });

    if (!user || !user.isActive) {
      return null;
    }

    return user;
  }

  /**
   * Validate invite token or code and return member details
   */
  async validateInvite(tokenOrCode: string) {
    // Find invite by token (long) or inviteCode (6-digit)
    // Try by token first (unique constraint)
    let inviteToken = await this.prisma.inviteToken.findUnique({
      where: { token: tokenOrCode },
      include: {
        member: {
          include: {
            organization: {
              select: {
                id: true,
                name: true,
                logo: true,
              },
            },
          },
        },
      },
    });

    // If not found by token, try by inviteCode
    if (!inviteToken) {
      inviteToken = await this.prisma.inviteToken.findFirst({
        where: {
          inviteCode: tokenOrCode.toUpperCase(),
          isValid: true,
        },
        include: {
          member: {
            include: {
              organization: {
                select: {
                  id: true,
                  name: true,
                  logo: true,
                },
              },
            },
          },
        },
      });
    }

    if (!inviteToken) {
      throw new BadRequestException('Invalid invite code or token');
    }

    if (!inviteToken.isValid) {
      throw new BadRequestException('Invite token has been used or invalidated');
    }

    if (new Date() > inviteToken.expiresAt) {
      throw new BadRequestException('Invite token has expired');
    }

    if (inviteToken.member.userId) {
      throw new BadRequestException('Member already has an active account');
    }

    return {
      valid: true,
      member: {
        firstName: inviteToken.member.firstName,
        lastName: inviteToken.member.lastName,
        email: inviteToken.member.email,
        phone: inviteToken.member.phone,
        phoneCountryCode: inviteToken.member.phoneCountryCode,
        photo: inviteToken.member.photo,
        organizationName: inviteToken.member.organization.name,
        organizationLogo: inviteToken.member.organization.logo,
      },
      expiresAt: inviteToken.expiresAt,
    };
  }

  /**
   * Complete invite and create user account
   */
  async completeInvite(completeInviteDto: CompleteInviteDto) {
    // Validate invite token
    const inviteToken = await this.prisma.inviteToken.findUnique({
      where: { inviteCode: completeInviteDto.token },
      include: {
        member: {
          include: {
            organization: true,
          },
        },
      },
    });

    if (!inviteToken) {
      throw new BadRequestException('Invalid invite token');
    }

    if (!inviteToken.isValid) {
      throw new BadRequestException('Invite token has been used or invalidated');
    }

    if (new Date() > inviteToken.expiresAt) {
      throw new BadRequestException('Invite token has expired');
    }

    if (inviteToken.member.userId) {
      throw new BadRequestException('Member already has an active account');
    }

    const member = inviteToken.member;

    // Check if one of password, googleIdToken, or appleAuthCode is provided
    if (!completeInviteDto.password && !completeInviteDto.googleIdToken && !completeInviteDto.appleAuthCode) {
      throw new BadRequestException('Password or OAuth provider is required');
    }

    // Hash password if provided
    let passwordHash: string | undefined;
    let googleId: string | undefined;
    let appleId: string | undefined;

    if (completeInviteDto.password) {
      passwordHash = await bcrypt.hash(completeInviteDto.password, 10);
    }

    if (completeInviteDto.googleIdToken) {
      // TODO: Verify Google ID token
      googleId = 'google-' + member.email;
    }

    if (completeInviteDto.appleAuthCode) {
      // TODO: Verify Apple auth code
      appleId = 'apple-' + member.email;
    }

    // Create user and link to member
    const result = await this.prisma.$transaction(async (tx) => {
      // Create user account
      const user = await tx.user.create({
        data: {
          organizationId: member.organizationId,
          email: member.email!,
          passwordHash,
          googleId,
          appleId,
          firstName: member.firstName,
          lastName: member.lastName,
          phone: member.phone,
          phoneCountryCode: member.phoneCountryCode,
          avatar: completeInviteDto.profilePhotoBase64
            ? await this.uploadProfilePhoto(
                completeInviteDto.profilePhotoBase64,
                member.organizationId,
              )
            : member.photo,
          role: UserRole.MEMBER,
          emailVerified: true, // Auto-verify since they came from invite
          isActive: true,
          lastLoginAt: new Date(),
          loginCount: 1,
        },
        select: {
          id: true,
          email: true,
          firstName: true,
          lastName: true,
          role: true,
          organizationId: true,
          avatar: true,
        },
      });

      // Link user to member
      await tx.member.update({
        where: { id: member.id },
        data: {
          userId: user.id,
          inviteStatus: 'ACTIVE',
          activatedAt: new Date(),
          photo: user.avatar || member.photo,
        },
      });

      // Mark invite token as used
      await tx.inviteToken.update({
        where: { id: inviteToken.id },
        data: {
          isValid: false,
          usedAt: new Date(),
        },
      });

      return user;
    });

    // Generate tokens
    const tokens = await this.generateTokens(result);

    return {
      user: result,
      organization: {
        id: member.organization.id,
        name: member.organization.name,
        subdomain: member.organization.subdomain,
        planType: member.organization.planType,
        subscriptionStatus: member.organization.subscriptionStatus,
        isActive: member.organization.isActive,
      },
      member: {
        id: member.id,
        firstName: member.firstName,
        lastName: member.lastName,
      },
      ...tokens,
    };
  }

  /**
   * Upload profile photo to Cloudinary
   */
  private async uploadProfilePhoto(
    base64: string,
    organizationId: string,
  ): Promise<string> {
    try {
      const cloudinaryUrl = await this.cloudinaryService.uploadBase64(
        base64,
        'profile-pictures',
        organizationId,
      );
      return cloudinaryUrl;
    } catch (error) {
      console.error('[UPLOAD] Failed to upload profile photo to Cloudinary:', error);
      // Fallback to base64 if Cloudinary fails (though this is not ideal)
      return base64;
    }
  }
}
