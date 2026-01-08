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
  Req,
  Headers,
  HttpCode,
  HttpStatus,
  RawBodyRequest,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiResponse,
  ApiParam,
  ApiExcludeEndpoint,
} from '@nestjs/swagger';
import { DonationsService } from './donations.service';
import {
  CreateDonationDto,
  CreateRecurringDonationDto,
  UpdateDonationDto,
  QueryDonationDto,
  CancelRecurringDonationDto,
} from './dto';
import { JwtAuthGuard } from '@/common/guards/jwt-auth.guard';
import { TenantGuard } from '@/common/guards/tenant.guard';
import { RolesGuard } from '@/common/guards/roles.guard';
import { Roles } from '@/common/decorators/roles.decorator';
import { CurrentOrg } from '@/common/decorators/current-org.decorator';
import { CurrentUser } from '@/common/decorators/current-user.decorator';
import { Public } from '@/common/decorators/public.decorator';
import { UserRole } from '@prisma/client';
import { StripeService } from '@/core/stripe/stripe.service';
import { Request } from 'express';

/**
 * Donations Controller - Handles all giving/donation endpoints
 * Supports one-time donations, recurring donations, and Stripe webhooks
 */
@ApiTags('donations')
@Controller('donations')
@UseGuards(JwtAuthGuard, TenantGuard, RolesGuard)
@ApiBearerAuth('JWT-auth')
export class DonationsController {
  constructor(
    private readonly donationsService: DonationsService,
    private readonly stripeService: StripeService,
  ) {}

  @Post()
  @Roles(
    UserRole.ADMIN,
    UserRole.PASTOR,
    UserRole.USHER,
    UserRole.MEMBER,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Create a one-time donation' })
  @ApiResponse({ status: 201, description: 'Donation processed successfully' })
  @ApiResponse({ status: 400, description: 'Payment failed or invalid data' })
  @ApiResponse({ status: 403, description: 'Forbidden' })
  createDonation(
    @Body() createDto: CreateDonationDto,
    @CurrentOrg() organizationId: string,
    @CurrentUser() user: any,
  ) {
    return this.donationsService.createOneTimeDonation(
      createDto,
      organizationId,
      user.id,
    );
  }

  @Post('recurring')
  @Roles(
    UserRole.ADMIN,
    UserRole.PASTOR,
    UserRole.USHER,
    UserRole.MEMBER,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Create a recurring donation (subscription)' })
  @ApiResponse({ status: 201, description: 'Recurring donation created successfully' })
  @ApiResponse({ status: 400, description: 'Subscription creation failed' })
  @ApiResponse({ status: 403, description: 'Forbidden' })
  createRecurringDonation(
    @Body() createDto: CreateRecurringDonationDto,
    @CurrentOrg() organizationId: string,
    @CurrentUser() user: any,
  ) {
    return this.donationsService.createRecurringDonation(
      createDto,
      organizationId,
      user.id,
    );
  }

  @Get()
  @Roles(UserRole.ADMIN, UserRole.PASTOR, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Get all donations with filtering and pagination' })
  @ApiResponse({ status: 200, description: 'Donations list retrieved' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin/Pastor only' })
  findAll(@CurrentOrg() organizationId: string, @Query() query: QueryDonationDto) {
    return this.donationsService.findAll(organizationId, query);
  }

  @Get('stats')
  @Roles(UserRole.ADMIN, UserRole.PASTOR, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Get donation statistics and reports' })
  @ApiResponse({ status: 200, description: 'Statistics retrieved' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin/Pastor only' })
  getStats(
    @CurrentOrg() organizationId: string,
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
  ) {
    const dateRange =
      startDate && endDate
        ? {
            start: new Date(startDate),
            end: new Date(endDate),
          }
        : undefined;

    return this.donationsService.getStats(organizationId, dateRange);
  }

  @Get('my-donations')
  @Roles(
    UserRole.ADMIN,
    UserRole.PASTOR,
    UserRole.USHER,
    UserRole.MEMBER,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Get current user donations' })
  @ApiResponse({ status: 200, description: 'User donations retrieved' })
  getMyDonations(@CurrentUser() user: any, @Query() query: QueryDonationDto) {
    // Override query to only show user's donations
    const userQuery = { ...query, userId: user.id };
    return this.donationsService.findAll(user.organizationId, userQuery);
  }

  @Get(':id')
  @Roles(UserRole.ADMIN, UserRole.PASTOR, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Get donation by ID' })
  @ApiParam({ name: 'id', description: 'Donation UUID' })
  @ApiResponse({ status: 200, description: 'Donation details retrieved' })
  @ApiResponse({ status: 404, description: 'Donation not found' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin/Pastor only' })
  findOne(@Param('id') id: string, @CurrentOrg() organizationId: string) {
    return this.donationsService.findOne(id, organizationId);
  }

  @Patch(':id')
  @Roles(UserRole.ADMIN, UserRole.PASTOR, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Update donation metadata (notes, anonymous flag)' })
  @ApiParam({ name: 'id', description: 'Donation UUID' })
  @ApiResponse({ status: 200, description: 'Donation updated successfully' })
  @ApiResponse({ status: 404, description: 'Donation not found' })
  @ApiResponse({ status: 403, description: 'Forbidden - Admin/Pastor only' })
  update(
    @Param('id') id: string,
    @Body() updateDto: UpdateDonationDto,
    @CurrentOrg() organizationId: string,
  ) {
    return this.donationsService.update(id, updateDto, organizationId);
  }

  @Delete(':id/recurring')
  @Roles(
    UserRole.ADMIN,
    UserRole.PASTOR,
    UserRole.MEMBER,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Cancel a recurring donation subscription' })
  @ApiParam({ name: 'id', description: 'Donation UUID' })
  @ApiResponse({ status: 200, description: 'Recurring donation canceled' })
  @ApiResponse({ status: 404, description: 'Recurring donation not found' })
  @ApiResponse({ status: 400, description: 'No active subscription found' })
  @ApiResponse({ status: 403, description: 'Forbidden' })
  cancelRecurring(
    @Param('id') id: string,
    @Body() cancelDto: CancelRecurringDonationDto,
    @CurrentOrg() organizationId: string,
  ) {
    return this.donationsService.cancelRecurringDonation(id, cancelDto, organizationId);
  }

  /**
   * Stripe Webhook Endpoint
   * IMPORTANT: This endpoint must be public and receive raw body
   * Configure in Stripe Dashboard: https://dashboard.stripe.com/webhooks
   */
  @Public()
  @Post('webhook')
  @HttpCode(HttpStatus.OK)
  @ApiExcludeEndpoint() // Hide from Swagger docs
  async handleWebhook(
    @Req() request: RawBodyRequest<Request>,
    @Headers('stripe-signature') signature: string,
  ) {
    // Verify webhook signature
    const event = this.stripeService.verifyWebhookSignature(
      request.rawBody || request.body,
      signature,
    );

    // Process webhook event
    return this.donationsService.handleWebhook(event);
  }
}
