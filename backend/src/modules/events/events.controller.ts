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
import { EventsService } from './events.service';
import { CreateEventDto, UpdateEventDto, QueryEventDto, RegisterEventDto } from './dto';
import { JwtAuthGuard } from '@/common/guards/jwt-auth.guard';
import { TenantGuard } from '@/common/guards/tenant.guard';
import { RolesGuard } from '@/common/guards/roles.guard';
import { Roles } from '@/common/decorators/roles.decorator';
import { CurrentOrg } from '@/common/decorators/current-org.decorator';
import { CurrentUser } from '@/common/decorators/current-user.decorator';
import { Public } from '@/common/decorators/public.decorator';
import { UserRole } from '@prisma/client';

/**
 * Events Controller - Handles event management and registration
 */
@ApiTags('events')
@Controller('events')
@UseGuards(JwtAuthGuard, TenantGuard, RolesGuard)
@ApiBearerAuth('JWT-auth')
export class EventsController {
  constructor(private readonly eventsService: EventsService) {}

  @Post()
  @Roles(UserRole.ADMIN, UserRole.PASTOR, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Create a new event' })
  @ApiResponse({ status: 201, description: 'Event created successfully' })
  @ApiResponse({ status: 400, description: 'Invalid data' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin/Pastor only' })
  create(
    @Body() createDto: CreateEventDto,
    @CurrentOrg() organizationId: string,
    @CurrentUser() user: any,
  ) {
    return this.eventsService.create(createDto, organizationId, user.id);
  }

  @Get()
  @Roles(
    UserRole.ADMIN,
    UserRole.PASTOR,
    UserRole.USHER,
    UserRole.MEMBER,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Get all events with filtering and pagination' })
  @ApiResponse({ status: 200, description: 'Events list retrieved' })
  findAll(@CurrentOrg() organizationId: string, @Query() query: QueryEventDto) {
    return this.eventsService.findAll(organizationId, query);
  }

  @Get('stats')
  @Roles(UserRole.ADMIN, UserRole.PASTOR, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Get event statistics' })
  @ApiResponse({ status: 200, description: 'Statistics retrieved' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin/Pastor only' })
  getStats(@CurrentOrg() organizationId: string) {
    return this.eventsService.getStats(organizationId);
  }

  @Get(':id')
  @Roles(
    UserRole.ADMIN,
    UserRole.PASTOR,
    UserRole.USHER,
    UserRole.MEMBER,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Get event by ID with registration details' })
  @ApiParam({ name: 'id', description: 'Event UUID' })
  @ApiResponse({ status: 200, description: 'Event details retrieved' })
  @ApiResponse({ status: 404, description: 'Event not found' })
  findOne(@Param('id') id: string, @CurrentOrg() organizationId: string) {
    return this.eventsService.findOne(id, organizationId);
  }

  @Get(':id/qr-code')
  @Roles(
    UserRole.ADMIN,
    UserRole.PASTOR,
    UserRole.USHER,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Get event QR code (data URL)' })
  @ApiParam({ name: 'id', description: 'Event UUID' })
  @ApiResponse({ status: 200, description: 'QR code data URL returned' })
  @ApiResponse({ status: 404, description: 'Event not found' })
  @ApiResponse({ status: 403, description: 'Forbidden' })
  getQRCode(@Param('id') id: string, @CurrentOrg() organizationId: string) {
    return this.eventsService.getQRCode(id, organizationId);
  }

  @Post(':id/register')
  @ApiOperation({ summary: 'Register for an event' })
  @ApiParam({ name: 'id', description: 'Event UUID' })
  @ApiResponse({ status: 201, description: 'Registration successful' })
  @ApiResponse({ status: 400, description: 'Registration failed or event is full' })
  @ApiResponse({ status: 404, description: 'Event not found' })
  @ApiResponse({ status: 409, description: 'Already registered' })
  register(
    @Param('id') id: string,
    @Body() registerDto: RegisterEventDto,
    @CurrentOrg() organizationId: string,
    @CurrentUser() user: any,
  ) {
    return this.eventsService.register(id, registerDto, organizationId, user?.id);
  }

  @Delete(':id/register')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Cancel event registration' })
  @ApiParam({ name: 'id', description: 'Event UUID' })
  @ApiResponse({ status: 200, description: 'Registration cancelled' })
  @ApiResponse({ status: 404, description: 'Registration not found' })
  @ApiResponse({ status: 400, description: 'Cannot cancel - event has started' })
  cancelRegistration(
    @Param('id') id: string,
    @CurrentOrg() organizationId: string,
    @CurrentUser() user: any,
  ) {
    return this.eventsService.cancelRegistration(id, organizationId, user.id);
  }

  @Patch(':id')
  @Roles(UserRole.ADMIN, UserRole.PASTOR, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Update event details' })
  @ApiParam({ name: 'id', description: 'Event UUID' })
  @ApiResponse({ status: 200, description: 'Event updated successfully' })
  @ApiResponse({ status: 404, description: 'Event not found' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin/Pastor only' })
  update(
    @Param('id') id: string,
    @Body() updateDto: UpdateEventDto,
    @CurrentOrg() organizationId: string,
    @CurrentUser() user: any,
  ) {
    return this.eventsService.update(id, updateDto, organizationId, user.id);
  }

  @Delete(':id')
  @Roles(UserRole.ADMIN, UserRole.PASTOR, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Delete event (only if no registrations)' })
  @ApiParam({ name: 'id', description: 'Event UUID' })
  @ApiResponse({ status: 200, description: 'Event deleted successfully' })
  @ApiResponse({ status: 404, description: 'Event not found' })
  @ApiResponse({ status: 400, description: 'Cannot delete - event has registrations' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin/Pastor only' })
  remove(@Param('id') id: string, @CurrentOrg() organizationId: string) {
    return this.eventsService.remove(id, organizationId);
  }
}
