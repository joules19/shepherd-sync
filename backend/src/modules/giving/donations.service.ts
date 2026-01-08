import {
  Injectable,
  NotFoundException,
  BadRequestException,
  InternalServerErrorException,
} from '@nestjs/common';
import { PrismaService } from '@/core/database/prisma.service';
import { StripeService } from '@/core/stripe/stripe.service';
import { EmailService } from '@/core/email/email.service';
import { ConfigService } from '@nestjs/config';
import {
  CreateDonationDto,
  CreateRecurringDonationDto,
  UpdateDonationDto,
  QueryDonationDto,
  CancelRecurringDonationDto,
  RecurringSchedule,
  StripeEventType,
} from './dto';
import { createPaginatedResponse, PaginatedResult } from '@/common/types/pagination.interface';
import { PaymentStatus, Prisma } from '@prisma/client';
import Stripe from 'stripe';
import { randomBytes } from 'crypto';

/**
 * Donations Service - Handles all giving/donation operations
 * Integrates with Stripe for payment processing
 * Sends receipts via Postmark
 */
@Injectable()
export class DonationsService {
  constructor(
    private prisma: PrismaService,
    private stripeService: StripeService,
    private emailService: EmailService,
    private configService: ConfigService,
  ) {}

  /**
   * Create a one-time donation
   */
  async createOneTimeDonation(
    createDto: CreateDonationDto,
    organizationId: string,
    userId?: string,
  ) {
    try {
      // Get organization for currency
      const organization = await this.prisma.organization.findUnique({
        where: { id: organizationId },
      });

      if (!organization) {
        throw new NotFoundException('Organization not found');
      }

      const currency = createDto.currency || organization.currency;

      // Validate payment method for Stripe
      if (
        createDto.paymentMethod !== 'CREDIT_CARD' &&
        createDto.paymentMethod !== 'DEBIT_CARD'
      ) {
        throw new BadRequestException(
          'Only credit and debit cards are supported for online donations',
        );
      }

      // Generate receipt number
      const receiptNumber = this.generateReceiptNumber();

      // Create donation record first (PENDING status)
      const donation = await this.prisma.donation.create({
        data: {
          organizationId,
          userId,
          amount: new Prisma.Decimal(createDto.amount),
          currency,
          donationType: createDto.donationType,
          paymentMethod: createDto.paymentMethod,
          paymentStatus: PaymentStatus.PENDING,
          donorName: createDto.donorName,
          donorEmail: createDto.donorEmail,
          donorPhone: createDto.donorPhone,
          notes: createDto.notes,
          isAnonymous: createDto.isAnonymous || false,
          receiptNumber,
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

      // Process payment with Stripe
      try {
        const paymentIntent = await this.stripeService.createPaymentIntent({
          amount: createDto.amount,
          currency,
          paymentMethodId: createDto.stripePaymentMethodId,
          customerEmail: createDto.donorEmail || donation.user?.email,
          customerName: createDto.donorName || `${donation.user?.firstName} ${donation.user?.lastName}`,
          metadata: {
            donationId: donation.id,
            organizationId,
            donationType: createDto.donationType,
            receiptNumber,
          },
        });

        // Update donation with payment intent details
        const updatedDonation = await this.prisma.donation.update({
          where: { id: donation.id },
          data: {
            stripePaymentIntentId: paymentIntent.id,
            stripeChargeId: paymentIntent.latest_charge as string,
            paymentStatus:
              paymentIntent.status === 'succeeded'
                ? PaymentStatus.COMPLETED
                : PaymentStatus.PENDING,
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

        // Send receipt if payment succeeded
        if (paymentIntent.status === 'succeeded') {
          await this.sendDonationReceipt(updatedDonation);
        }

        return updatedDonation;
      } catch (error) {
        // Mark donation as FAILED
        await this.prisma.donation.update({
          where: { id: donation.id },
          data: { paymentStatus: PaymentStatus.FAILED },
        });

        throw error;
      }
    } catch (error) {
      if (
        error instanceof NotFoundException ||
        error instanceof BadRequestException
      ) {
        throw error;
      }
      throw new InternalServerErrorException('Failed to process donation');
    }
  }

  /**
   * Create a recurring donation (subscription)
   */
  async createRecurringDonation(
    createDto: CreateRecurringDonationDto,
    organizationId: string,
    userId?: string,
  ) {
    try {
      // Get organization for currency
      const organization = await this.prisma.organization.findUnique({
        where: { id: organizationId },
      });

      if (!organization) {
        throw new NotFoundException('Organization not found');
      }

      const currency = createDto.currency || organization.currency;

      // Validate payment method
      if (
        createDto.paymentMethod !== 'CREDIT_CARD' &&
        createDto.paymentMethod !== 'DEBIT_CARD'
      ) {
        throw new BadRequestException(
          'Only credit and debit cards are supported for recurring donations',
        );
      }

      // Get user email for customer creation
      let customerEmail = createDto.donorEmail;
      let customerName = createDto.donorName;

      if (userId) {
        const user = await this.prisma.user.findUnique({
          where: { id: userId },
        });
        customerEmail = customerEmail || user?.email;
        customerName = customerName || `${user?.firstName} ${user?.lastName}`;
      }

      if (!customerEmail) {
        throw new BadRequestException('Email is required for recurring donations');
      }

      // Create or get Stripe customer
      const customer = await this.stripeService.createOrGetCustomer({
        email: customerEmail,
        name: customerName,
        phone: createDto.donorPhone,
        userId,
      });

      // Attach payment method to customer
      await this.stripeService.attachPaymentMethodToCustomer(
        createDto.stripePaymentMethodId,
        customer.id,
      );

      // Convert schedule to Stripe interval
      const { interval, intervalCount } = this.convertScheduleToInterval(
        createDto.recurringSchedule,
      );

      // Create Stripe subscription
      const subscription = await this.stripeService.createSubscription({
        customerId: customer.id,
        paymentMethodId: createDto.stripePaymentMethodId,
        amount: createDto.amount,
        currency,
        interval,
        intervalCount,
        metadata: {
          organizationId,
          userId: userId || '',
          donationType: createDto.donationType,
          isRecurring: 'true',
        },
      });

      // Calculate next recurring donation date
      const nextRecurringDate = this.calculateNextRecurringDate(
        createDto.recurringSchedule,
      );

      // Generate receipt number
      const receiptNumber = this.generateReceiptNumber();

      // Create donation record
      const donation = await this.prisma.donation.create({
        data: {
          organizationId,
          userId,
          amount: new Prisma.Decimal(createDto.amount),
          currency,
          donationType: createDto.donationType,
          paymentMethod: createDto.paymentMethod,
          paymentStatus: PaymentStatus.COMPLETED,
          donorName: customerName,
          donorEmail: customerEmail,
          donorPhone: createDto.donorPhone,
          notes: createDto.notes,
          isAnonymous: createDto.isAnonymous || false,
          isRecurring: true,
          recurringSchedule: createDto.recurringSchedule,
          stripeSubscriptionId: subscription.id,
          stripePaymentIntentId: (subscription.latest_invoice as any)?.payment_intent?.id,
          nextRecurringDonationAt: nextRecurringDate,
          receiptNumber,
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

      // Send confirmation email
      await this.sendRecurringDonationConfirmation(donation);

      return donation;
    } catch (error) {
      if (
        error instanceof NotFoundException ||
        error instanceof BadRequestException
      ) {
        throw error;
      }
      throw new InternalServerErrorException('Failed to create recurring donation');
    }
  }

  /**
   * Get all donations with filtering and pagination
   */
  async findAll(
    organizationId: string,
    query: QueryDonationDto,
  ): Promise<PaginatedResult<any>> {
    const {
      page = 1,
      limit = 20,
      search,
      donationType,
      paymentMethod,
      paymentStatus,
      isRecurring,
      isAnonymous,
      createdAfter,
      createdBefore,
      userId,
      sortBy = 'createdAt',
      sortOrder = 'desc',
    } = query;

    const where: any = {
      organizationId,
    };

    // Search by donor name or email
    if (search) {
      where.OR = [
        { donorName: { contains: search, mode: 'insensitive' } },
        { donorEmail: { contains: search, mode: 'insensitive' } },
      ];
    }

    // Apply filters
    if (donationType) where.donationType = donationType;
    if (paymentMethod) where.paymentMethod = paymentMethod;
    if (paymentStatus) where.paymentStatus = paymentStatus;
    if (isRecurring !== undefined) where.isRecurring = isRecurring;
    if (isAnonymous !== undefined) where.isAnonymous = isAnonymous;
    if (userId) where.userId = userId;

    // Date range filter
    if (createdAfter || createdBefore) {
      where.createdAt = {};
      if (createdAfter) {
        where.createdAt.gte = new Date(createdAfter);
      }
      if (createdBefore) {
        where.createdAt.lte = new Date(createdBefore);
      }
    }

    // Get total count
    const total = await this.prisma.donation.count({ where });

    // Build orderBy
    const orderBy: any = {};
    orderBy[sortBy] = sortOrder;

    // Get paginated results
    const donations = await this.prisma.donation.findMany({
      where,
      skip: (page - 1) * limit,
      take: limit,
      orderBy,
      select: {
        id: true,
        amount: true,
        currency: true,
        donationType: true,
        paymentMethod: true,
        paymentStatus: true,
        donorName: true,
        donorEmail: true,
        isAnonymous: true,
        isRecurring: true,
        receiptNumber: true,
        createdAt: true,
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

    return createPaginatedResponse(donations, total, page, limit);
  }

  /**
   * Get single donation by ID
   */
  async findOne(id: string, organizationId: string) {
    const donation = await this.prisma.donation.findFirst({
      where: {
        id,
        organizationId,
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

    if (!donation) {
      throw new NotFoundException('Donation not found');
    }

    return donation;
  }

  /**
   * Update donation metadata (notes, anonymous flag)
   */
  async update(id: string, updateDto: UpdateDonationDto, organizationId: string) {
    const donation = await this.prisma.donation.findFirst({
      where: {
        id,
        organizationId,
      },
    });

    if (!donation) {
      throw new NotFoundException('Donation not found');
    }

    return this.prisma.donation.update({
      where: { id },
      data: {
        notes: updateDto.notes,
        isAnonymous: updateDto.isAnonymous,
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
  }

  /**
   * Cancel recurring donation
   */
  async cancelRecurringDonation(
    id: string,
    cancelDto: CancelRecurringDonationDto,
    organizationId: string,
  ) {
    const donation = await this.prisma.donation.findFirst({
      where: {
        id,
        organizationId,
        isRecurring: true,
      },
    });

    if (!donation) {
      throw new NotFoundException('Recurring donation not found');
    }

    if (!donation.stripeSubscriptionId) {
      throw new BadRequestException('No active subscription found');
    }

    // Cancel subscription in Stripe
    await this.stripeService.cancelSubscription(
      donation.stripeSubscriptionId,
      cancelDto.cancelImmediately || false,
    );

    // Update donation record
    const updated = await this.prisma.donation.update({
      where: { id },
      data: {
        paymentStatus: PaymentStatus.CANCELED,
        notes: cancelDto.cancellationReason
          ? `${donation.notes || ''}\nCancellation reason: ${cancelDto.cancellationReason}`
          : donation.notes,
      },
    });

    return {
      message: cancelDto.cancelImmediately
        ? 'Recurring donation canceled immediately'
        : 'Recurring donation will be canceled at the end of the billing period',
      donation: updated,
    };
  }

  /**
   * Get donation statistics
   */
  async getStats(organizationId: string, dateRange?: { start: Date; end: Date }) {
    const where: any = {
      organizationId,
      paymentStatus: PaymentStatus.COMPLETED,
    };

    if (dateRange) {
      where.createdAt = {
        gte: dateRange.start,
        lte: dateRange.end,
      };
    }

    const [
      totalDonations,
      totalAmount,
      donationsByType,
      donationsByMethod,
      recurringDonations,
      averageDonation,
      topDonors,
    ] = await Promise.all([
      // Total donations count
      this.prisma.donation.count({ where }),

      // Total amount
      this.prisma.donation.aggregate({
        where,
        _sum: { amount: true },
      }),

      // Group by donation type
      this.prisma.donation.groupBy({
        by: ['donationType'],
        where,
        _sum: { amount: true },
        _count: true,
      }),

      // Group by payment method
      this.prisma.donation.groupBy({
        by: ['paymentMethod'],
        where,
        _count: true,
      }),

      // Recurring donations count
      this.prisma.donation.count({
        where: { ...where, isRecurring: true },
      }),

      // Average donation
      this.prisma.donation.aggregate({
        where,
        _avg: { amount: true },
      }),

      // Top donors (non-anonymous)
      this.prisma.donation.groupBy({
        by: ['userId'],
        where: { ...where, isAnonymous: false, userId: { not: null } },
        _sum: { amount: true },
        _count: true,
        orderBy: { _sum: { amount: 'desc' } },
        take: 10,
      }),
    ]);

    return {
      totalDonations,
      totalAmount: totalAmount._sum.amount || 0,
      averageDonation: averageDonation._avg.amount || 0,
      recurringDonations,
      byType: donationsByType.map((d) => ({
        type: d.donationType,
        count: d._count,
        total: d._sum.amount || 0,
      })),
      byMethod: donationsByMethod.map((d) => ({
        method: d.paymentMethod,
        count: d._count,
      })),
      topDonors: await this.enrichTopDonors(topDonors),
    };
  }

  /**
   * Handle Stripe webhook events
   */
  async handleWebhook(event: Stripe.Event) {
    switch (event.type) {
      case StripeEventType.PAYMENT_INTENT_SUCCEEDED:
        await this.handlePaymentIntentSucceeded(event.data.object as Stripe.PaymentIntent);
        break;

      case StripeEventType.PAYMENT_INTENT_FAILED:
        await this.handlePaymentIntentFailed(event.data.object as Stripe.PaymentIntent);
        break;

      case StripeEventType.INVOICE_PAYMENT_SUCCEEDED:
        await this.handleInvoicePaymentSucceeded(event.data.object as Stripe.Invoice);
        break;

      case StripeEventType.INVOICE_PAYMENT_FAILED:
        await this.handleInvoicePaymentFailed(event.data.object as Stripe.Invoice);
        break;

      case StripeEventType.CUSTOMER_SUBSCRIPTION_DELETED:
        await this.handleSubscriptionDeleted(event.data.object as Stripe.Subscription);
        break;

      case StripeEventType.CHARGE_REFUNDED:
        await this.handleChargeRefunded(event.data.object as Stripe.Charge);
        break;

      default:
        console.log(`Unhandled webhook event type: ${event.type}`);
    }

    return { received: true };
  }

  // ========================================
  // PRIVATE HELPER METHODS
  // ========================================

  private async handlePaymentIntentSucceeded(paymentIntent: Stripe.PaymentIntent) {
    const donation = await this.prisma.donation.findUnique({
      where: { stripePaymentIntentId: paymentIntent.id },
      include: { user: true },
    });

    if (donation) {
      await this.prisma.donation.update({
        where: { id: donation.id },
        data: {
          paymentStatus: PaymentStatus.COMPLETED,
          stripeChargeId: paymentIntent.latest_charge as string,
        },
      });

      await this.sendDonationReceipt(donation);
    }
  }

  private async handlePaymentIntentFailed(paymentIntent: Stripe.PaymentIntent) {
    const donation = await this.prisma.donation.findUnique({
      where: { stripePaymentIntentId: paymentIntent.id },
    });

    if (donation) {
      await this.prisma.donation.update({
        where: { id: donation.id },
        data: { paymentStatus: PaymentStatus.FAILED },
      });
    }
  }

  private async handleInvoicePaymentSucceeded(invoice: Stripe.Invoice) {
    // This is for recurring donations
    const subscriptionId = invoice.subscription as string;

    if (subscriptionId) {
      // Find the original donation with this subscription
      const originalDonation = await this.prisma.donation.findFirst({
        where: { stripeSubscriptionId: subscriptionId },
      });

      if (originalDonation && originalDonation.recurringSchedule) {
        // Update next recurring date
        const nextDate = this.calculateNextRecurringDate(
          originalDonation.recurringSchedule,
        );

        await this.prisma.donation.update({
          where: { id: originalDonation.id },
          data: { nextRecurringDonationAt: nextDate },
        });
      }
    }
  }

  private async handleInvoicePaymentFailed(invoice: Stripe.Invoice) {
    // Handle failed recurring payment
    const subscriptionId = invoice.subscription as string;

    if (subscriptionId) {
      const donation = await this.prisma.donation.findFirst({
        where: { stripeSubscriptionId: subscriptionId },
      });

      if (donation) {
        // Notify user of failed payment
        if (donation.donorEmail) {
          await this.emailService.sendTransactional(
            donation.donorEmail,
            'recurring-donation-failed',
            {
              donorName: donation.donorName,
              amount: donation.amount.toString(),
              currency: donation.currency,
            },
          );
        }
      }
    }
  }

  private async handleSubscriptionDeleted(subscription: Stripe.Subscription) {
    const donation = await this.prisma.donation.findFirst({
      where: { stripeSubscriptionId: subscription.id },
    });

    if (donation) {
      await this.prisma.donation.update({
        where: { id: donation.id },
        data: { paymentStatus: PaymentStatus.CANCELED },
      });
    }
  }

  private async handleChargeRefunded(charge: Stripe.Charge) {
    const donation = await this.prisma.donation.findFirst({
      where: { stripeChargeId: charge.id },
    });

    if (donation) {
      await this.prisma.donation.update({
        where: { id: donation.id },
        data: { paymentStatus: PaymentStatus.REFUNDED },
      });
    }
  }

  private async sendDonationReceipt(donation: any) {
    const recipientEmail = donation.donorEmail || donation.user?.email;

    if (!recipientEmail) {
      return;
    }

    const donorName =
      donation.donorName || `${donation.user?.firstName} ${donation.user?.lastName}`;

    await this.emailService.sendTransactional(recipientEmail, 'donation-receipt', {
      donorName,
      amount: donation.amount.toString(),
      currency: donation.currency,
      donationType: donation.donationType,
      receiptNumber: donation.receiptNumber,
      date: donation.createdAt.toLocaleDateString(),
    });

    // Update receipt sent timestamp
    await this.prisma.donation.update({
      where: { id: donation.id },
      data: { receiptSentAt: new Date() },
    });
  }

  private async sendRecurringDonationConfirmation(donation: any) {
    const recipientEmail = donation.donorEmail || donation.user?.email;

    if (!recipientEmail) {
      return;
    }

    const donorName =
      donation.donorName || `${donation.user?.firstName} ${donation.user?.lastName}`;

    await this.emailService.sendTransactional(
      recipientEmail,
      'recurring-donation-confirmation',
      {
        donorName,
        amount: donation.amount.toString(),
        currency: donation.currency,
        donationType: donation.donationType,
        schedule: donation.recurringSchedule,
        nextDate: donation.nextRecurringDonationAt?.toLocaleDateString(),
      },
    );
  }

  private convertScheduleToInterval(schedule: RecurringSchedule): {
    interval: 'week' | 'month' | 'year';
    intervalCount: number;
  } {
    switch (schedule) {
      case RecurringSchedule.WEEKLY:
        return { interval: 'week', intervalCount: 1 };
      case RecurringSchedule.BIWEEKLY:
        return { interval: 'week', intervalCount: 2 };
      case RecurringSchedule.MONTHLY:
        return { interval: 'month', intervalCount: 1 };
      case RecurringSchedule.QUARTERLY:
        return { interval: 'month', intervalCount: 3 };
      case RecurringSchedule.ANNUALLY:
        return { interval: 'year', intervalCount: 1 };
      default:
        return { interval: 'month', intervalCount: 1 };
    }
  }

  private calculateNextRecurringDate(schedule: string): Date {
    const now = new Date();

    switch (schedule) {
      case RecurringSchedule.WEEKLY:
        return new Date(now.setDate(now.getDate() + 7));
      case RecurringSchedule.BIWEEKLY:
        return new Date(now.setDate(now.getDate() + 14));
      case RecurringSchedule.MONTHLY:
        return new Date(now.setMonth(now.getMonth() + 1));
      case RecurringSchedule.QUARTERLY:
        return new Date(now.setMonth(now.getMonth() + 3));
      case RecurringSchedule.ANNUALLY:
        return new Date(now.setFullYear(now.getFullYear() + 1));
      default:
        return new Date(now.setMonth(now.getMonth() + 1));
    }
  }

  private generateReceiptNumber(): string {
    const timestamp = Date.now().toString(36).toUpperCase();
    const random = randomBytes(3).toString('hex').toUpperCase();
    return `RCP-${timestamp}-${random}`;
  }

  private async enrichTopDonors(topDonors: any[]) {
    const enriched: Array<{
      user: { id: string; firstName: string; lastName: string; email: string } | null;
      totalAmount: any;
      donationCount: any;
    }> = [];

    for (const donor of topDonors) {
      if (donor.userId) {
        const user = await this.prisma.user.findUnique({
          where: { id: donor.userId },
          select: {
            id: true,
            firstName: true,
            lastName: true,
            email: true,
          },
        });

        enriched.push({
          user,
          totalAmount: donor._sum.amount || 0,
          donationCount: donor._count,
        });
      }
    }

    return enriched;
  }
}
