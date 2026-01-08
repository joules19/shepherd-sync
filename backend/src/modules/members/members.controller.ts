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
  Header,
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
import { MembersService } from './members.service';
import { CreateMemberDto } from './dto/create-member.dto';
import { UpdateMemberDto } from './dto/update-member.dto';
import { QueryMemberDto } from './dto/query-member.dto';
import { ImportMembersDto } from './dto/import-members.dto';
import { JwtAuthGuard } from '@/common/guards/jwt-auth.guard';
import { TenantGuard } from '@/common/guards/tenant.guard';
import { RolesGuard } from '@/common/guards/roles.guard';
import { Roles } from '@/common/decorators/roles.decorator';
import { CurrentOrg } from '@/common/decorators/current-org.decorator';
import { UserRole } from '@prisma/client';

@ApiTags('members')
@Controller('members')
@UseGuards(JwtAuthGuard, TenantGuard, RolesGuard)
@ApiBearerAuth('JWT-auth')
export class MembersController {
  constructor(private readonly membersService: MembersService) {}

  @Post()
  @Roles(UserRole.ADMIN, UserRole.PASTOR, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Create new member' })
  @ApiResponse({ status: 201, description: 'Member created successfully' })
  @ApiResponse({ status: 409, description: 'Member with email already exists' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin/Pastor only' })
  create(@Body() createDto: CreateMemberDto, @CurrentOrg() organizationId: string) {
    return this.membersService.create(createDto, organizationId);
  }

  @Post('import')
  @Roles(UserRole.ADMIN, UserRole.PASTOR, UserRole.SUPER_ADMIN)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Bulk import members from CSV/JSON' })
  @ApiResponse({ status: 200, description: 'Import completed (check result for details)' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin/Pastor only' })
  importMembers(@Body() importDto: ImportMembersDto, @CurrentOrg() organizationId: string) {
    return this.membersService.importMembers(importDto, organizationId);
  }

  @Get()
  @Roles(
    UserRole.ADMIN,
    UserRole.PASTOR,
    UserRole.USHER,
    UserRole.MEMBER,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Get all members with filtering and pagination' })
  @ApiResponse({ status: 200, description: 'Members list retrieved' })
  findAll(@CurrentOrg() organizationId: string, @Query() query: QueryMemberDto) {
    return this.membersService.findAll(organizationId, query);
  }

  @Get('stats')
  @Roles(UserRole.ADMIN, UserRole.PASTOR, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Get member statistics for dashboard' })
  @ApiResponse({ status: 200, description: 'Statistics retrieved' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin/Pastor only' })
  getStats(@CurrentOrg() organizationId: string) {
    return this.membersService.getStats(organizationId);
  }

  @Get('export')
  @Roles(UserRole.ADMIN, UserRole.PASTOR, UserRole.SUPER_ADMIN)
  @Header('Content-Type', 'text/csv')
  @Header('Content-Disposition', 'attachment; filename="members.csv"')
  @ApiOperation({ summary: 'Export members to CSV' })
  @ApiResponse({ status: 200, description: 'CSV file generated' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin/Pastor only' })
  async exportMembers(@CurrentOrg() organizationId: string, @Query() query: QueryMemberDto) {
    return this.membersService.exportMembers(organizationId, query);
  }

  @Get(':id')
  @Roles(
    UserRole.ADMIN,
    UserRole.PASTOR,
    UserRole.USHER,
    UserRole.MEMBER,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Get member by ID with attendance history' })
  @ApiParam({ name: 'id', description: 'Member UUID' })
  @ApiResponse({ status: 200, description: 'Member details retrieved' })
  @ApiResponse({ status: 404, description: 'Member not found' })
  findOne(@Param('id') id: string, @CurrentOrg() organizationId: string) {
    return this.membersService.findOne(id, organizationId);
  }

  @Patch(':id')
  @Roles(UserRole.ADMIN, UserRole.PASTOR, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Update member details' })
  @ApiParam({ name: 'id', description: 'Member UUID' })
  @ApiResponse({ status: 200, description: 'Member updated successfully' })
  @ApiResponse({ status: 404, description: 'Member not found' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin/Pastor only' })
  update(
    @Param('id') id: string,
    @Body() updateDto: UpdateMemberDto,
    @CurrentOrg() organizationId: string,
  ) {
    return this.membersService.update(id, updateDto, organizationId);
  }

  @Delete(':id')
  @Roles(UserRole.ADMIN, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Delete member (soft delete)' })
  @ApiParam({ name: 'id', description: 'Member UUID' })
  @ApiResponse({ status: 200, description: 'Member deleted successfully' })
  @ApiResponse({ status: 404, description: 'Member not found' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin only' })
  remove(@Param('id') id: string, @CurrentOrg() organizationId: string) {
    return this.membersService.remove(id, organizationId);
  }

  @Post(':id/restore')
  @Roles(UserRole.ADMIN, UserRole.SUPER_ADMIN)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Restore soft-deleted member' })
  @ApiParam({ name: 'id', description: 'Member UUID' })
  @ApiResponse({ status: 200, description: 'Member restored successfully' })
  @ApiResponse({ status: 404, description: 'Member not found' })
  @ApiResponse({ status: 400, description: 'Member is not deleted' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin only' })
  restore(@Param('id') id: string, @CurrentOrg() organizationId: string) {
    return this.membersService.restore(id, organizationId);
  }
}
