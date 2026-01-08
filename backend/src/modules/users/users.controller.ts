import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Query,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiResponse,
  ApiParam,
} from '@nestjs/swagger';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { QueryUserDto } from './dto/query-user.dto';
import { InviteUserDto } from './dto/invite-user.dto';
import { ChangePasswordDto } from './dto/change-password.dto';
import { RequestPasswordResetDto, ResetPasswordDto } from './dto/reset-password.dto';
import { JwtAuthGuard } from '@/common/guards/jwt-auth.guard';
import { TenantGuard } from '@/common/guards/tenant.guard';
import { RolesGuard } from '@/common/guards/roles.guard';
import { Roles } from '@/common/decorators/roles.decorator';
import { CurrentUser } from '@/common/decorators/current-user.decorator';
import { CurrentOrg } from '@/common/decorators/current-org.decorator';
import { Public } from '@/common/decorators/public.decorator';
import { UserRole } from '@prisma/client';

@ApiTags('users')
@Controller('users')
@UseGuards(JwtAuthGuard, TenantGuard, RolesGuard)
@ApiBearerAuth('JWT-auth')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  @Roles(UserRole.ADMIN, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Create new user in organization' })
  @ApiResponse({ status: 201, description: 'User created successfully' })
  @ApiResponse({ status: 409, description: 'Email already exists' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin only' })
  create(
    @Body() createDto: CreateUserDto,
    @CurrentOrg() organizationId: string,
    @CurrentUser() user: any,
  ) {
    return this.usersService.create(createDto, organizationId, user.role);
  }

  @Post('invite')
  @Roles(UserRole.ADMIN, UserRole.PASTOR, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Send invitation to new user' })
  @ApiResponse({ status: 201, description: 'Invitation sent successfully' })
  @ApiResponse({ status: 409, description: 'User already exists' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin/Pastor only' })
  inviteUser(
    @Body() inviteDto: InviteUserDto,
    @CurrentOrg() organizationId: string,
    @CurrentUser() user: any,
  ) {
    return this.usersService.inviteUser(inviteDto, organizationId, user.role);
  }

  @Post(':id/resend-invitation')
  @Roles(UserRole.ADMIN, UserRole.PASTOR, UserRole.SUPER_ADMIN)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Resend invitation email to user' })
  @ApiParam({ name: 'id', description: 'User UUID' })
  @ApiResponse({ status: 200, description: 'Invitation resent successfully' })
  @ApiResponse({ status: 404, description: 'User not found' })
  @ApiResponse({ status: 400, description: 'User has already accepted invitation' })
  resendInvitation(
    @Param('id') id: string,
    @CurrentOrg() organizationId: string,
  ) {
    return this.usersService.resendInvitation(id, organizationId);
  }

  @Get()
  @Roles(UserRole.ADMIN, UserRole.PASTOR, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Get all users in organization with filtering' })
  @ApiResponse({ status: 200, description: 'Users list retrieved' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin/Pastor only' })
  findAll(
    @CurrentOrg() organizationId: string,
    @Query() query: QueryUserDto,
  ) {
    return this.usersService.findAll(organizationId, query);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get user by ID' })
  @ApiParam({ name: 'id', description: 'User UUID' })
  @ApiResponse({ status: 200, description: 'User details retrieved' })
  @ApiResponse({ status: 404, description: 'User not found' })
  @ApiResponse({ status: 403, description: 'Forbidden - Can only view own profile or admin' })
  findOne(
    @Param('id') id: string,
    @CurrentOrg() organizationId: string,
    @CurrentUser() user: any,
  ) {
    return this.usersService.findOne(id, organizationId, user.role, user.id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update user details' })
  @ApiParam({ name: 'id', description: 'User UUID' })
  @ApiResponse({ status: 200, description: 'User updated successfully' })
  @ApiResponse({ status: 404, description: 'User not found' })
  @ApiResponse({ status: 403, description: 'Forbidden - Can only update own profile or admin' })
  update(
    @Param('id') id: string,
    @Body() updateDto: UpdateUserDto,
    @CurrentOrg() organizationId: string,
    @CurrentUser() user: any,
  ) {
    return this.usersService.update(id, updateDto, organizationId, user.role, user.id);
  }

  @Post('change-password')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Change current user password' })
  @ApiResponse({ status: 200, description: 'Password changed successfully' })
  @ApiResponse({ status: 401, description: 'Current password is incorrect' })
  changePassword(
    @Body() changePasswordDto: ChangePasswordDto,
    @CurrentUser() user: any,
  ) {
    return this.usersService.changePassword(user.id, changePasswordDto);
  }

  @Public()
  @Post('request-password-reset')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Request password reset email' })
  @ApiResponse({ status: 200, description: 'Reset email sent if user exists' })
  requestPasswordReset(@Body() requestDto: RequestPasswordResetDto) {
    return this.usersService.requestPasswordReset(requestDto);
  }

  @Public()
  @Post('reset-password')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Reset password with token from email' })
  @ApiResponse({ status: 200, description: 'Password reset successfully' })
  @ApiResponse({ status: 400, description: 'Invalid or expired token' })
  resetPassword(@Body() resetDto: ResetPasswordDto) {
    return this.usersService.resetPassword(resetDto);
  }

  @Public()
  @Post('verify-email')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Verify email address with token' })
  @ApiResponse({ status: 200, description: 'Email verified successfully' })
  @ApiResponse({ status: 400, description: 'Invalid or expired token' })
  verifyEmail(@Body('token') token: string) {
    return this.usersService.verifyEmail(token);
  }

  @Delete(':id')
  @Roles(UserRole.ADMIN, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Deactivate user (Admin only)' })
  @ApiParam({ name: 'id', description: 'User UUID' })
  @ApiResponse({ status: 200, description: 'User deactivated successfully' })
  @ApiResponse({ status: 404, description: 'User not found' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin only' })
  remove(
    @Param('id') id: string,
    @CurrentOrg() organizationId: string,
    @CurrentUser() user: any,
  ) {
    return this.usersService.remove(id, organizationId, user.role);
  }

  @Post(':id/reactivate')
  @Roles(UserRole.ADMIN, UserRole.SUPER_ADMIN)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Reactivate deactivated user (Admin only)' })
  @ApiParam({ name: 'id', description: 'User UUID' })
  @ApiResponse({ status: 200, description: 'User reactivated successfully' })
  @ApiResponse({ status: 404, description: 'User not found' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin only' })
  reactivate(
    @Param('id') id: string,
    @CurrentOrg() organizationId: string,
  ) {
    return this.usersService.reactivate(id, organizationId);
  }
}
