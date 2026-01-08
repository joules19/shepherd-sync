import { Injectable, BadRequestException, InternalServerErrorException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Stripe from 'stripe';

/**
 * Stripe Service - Handles all Stripe payment operations
 * Used for one-time donations and recurring donations (subscriptions)
 */
@Injectable()
export class StripeService {
  private stripe: Stripe;

  constructor(private configService: ConfigService) {
    const secretKey = this.configService.get<string>('STRIPE_SECRET_KEY');

    if (!secretKey) {
      throw new Error('STRIPE_SECRET_KEY is not configured');
    }

    this.stripe = new Stripe(secretKey, {
      apiVersion: '2023-10-16',
      typescript: true,
    });
  }

  /**
   * Get Stripe client instance
   */
  getClient(): Stripe {
    return this.stripe;
  }

  /**
   * Create a payment intent for one-time donations
   */
  async createPaymentIntent(params: {
    amount: number;
    currency: string;
    paymentMethodId: string;
    customerEmail?: string;
    customerName?: string;
    metadata?: Record<string, string>;
  }): Promise<Stripe.PaymentIntent> {
    try {
      // Amount should be in cents
      const amountInCents = Math.round(params.amount * 100);

      const paymentIntent = await this.stripe.paymentIntents.create({
        amount: amountInCents,
        currency: params.currency.toLowerCase(),
        payment_method: params.paymentMethodId,
        confirm: true,
        automatic_payment_methods: {
          enabled: true,
          allow_redirects: 'never',
        },
        receipt_email: params.customerEmail,
        metadata: {
          ...params.metadata,
          customerName: params.customerName || 'Anonymous',
        },
        return_url: this.configService.get<string>('FRONTEND_URL'),
      });

      return paymentIntent;
    } catch (error) {
      if (error instanceof Stripe.errors.StripeError) {
        throw new BadRequestException(`Payment failed: ${error.message}`);
      }
      throw new InternalServerErrorException('Payment processing failed');
    }
  }

  /**
   * Create or retrieve a Stripe customer
   */
  async createOrGetCustomer(params: {
    email: string;
    name?: string;
    phone?: string;
    userId?: string;
  }): Promise<Stripe.Customer> {
    try {
      // Check if customer already exists by email
      const existingCustomers = await this.stripe.customers.list({
        email: params.email,
        limit: 1,
      });

      if (existingCustomers.data.length > 0) {
        return existingCustomers.data[0];
      }

      // Create new customer
      const customer = await this.stripe.customers.create({
        email: params.email,
        name: params.name,
        phone: params.phone,
        metadata: {
          userId: params.userId || '',
        },
      });

      return customer;
    } catch (error) {
      if (error instanceof Stripe.errors.StripeError) {
        throw new BadRequestException(`Customer creation failed: ${error.message}`);
      }
      throw new InternalServerErrorException('Customer creation failed');
    }
  }

  /**
   * Attach payment method to customer
   */
  async attachPaymentMethodToCustomer(
    paymentMethodId: string,
    customerId: string,
  ): Promise<Stripe.PaymentMethod> {
    try {
      return await this.stripe.paymentMethods.attach(paymentMethodId, {
        customer: customerId,
      });
    } catch (error) {
      if (error instanceof Stripe.errors.StripeError) {
        throw new BadRequestException(`Payment method attachment failed: ${error.message}`);
      }
      throw new InternalServerErrorException('Payment method attachment failed');
    }
  }

  /**
   * Create a subscription for recurring donations
   */
  async createSubscription(params: {
    customerId: string;
    paymentMethodId: string;
    amount: number;
    currency: string;
    interval: 'week' | 'month' | 'year';
    intervalCount?: number;
    metadata?: Record<string, string>;
  }): Promise<Stripe.Subscription> {
    try {
      // Set the payment method as default for the customer
      await this.stripe.customers.update(params.customerId, {
        invoice_settings: {
          default_payment_method: params.paymentMethodId,
        },
      });

      // Amount should be in cents
      const amountInCents = Math.round(params.amount * 100);

      // Create a price for this subscription
      const price = await this.stripe.prices.create({
        unit_amount: amountInCents,
        currency: params.currency.toLowerCase(),
        recurring: {
          interval: params.interval,
          interval_count: params.intervalCount || 1,
        },
        product_data: {
          name: `Recurring Donation - ${params.metadata?.donationType || 'General'}`,
        },
      });

      // Create subscription
      const subscription = await this.stripe.subscriptions.create({
        customer: params.customerId,
        items: [{ price: price.id }],
        default_payment_method: params.paymentMethodId,
        metadata: params.metadata,
        expand: ['latest_invoice.payment_intent'],
      });

      return subscription;
    } catch (error) {
      if (error instanceof Stripe.errors.StripeError) {
        throw new BadRequestException(`Subscription creation failed: ${error.message}`);
      }
      throw new InternalServerErrorException('Subscription creation failed');
    }
  }

  /**
   * Cancel a subscription
   */
  async cancelSubscription(
    subscriptionId: string,
    cancelImmediately: boolean = false,
  ): Promise<Stripe.Subscription> {
    try {
      if (cancelImmediately) {
        return await this.stripe.subscriptions.cancel(subscriptionId);
      } else {
        // Cancel at period end
        return await this.stripe.subscriptions.update(subscriptionId, {
          cancel_at_period_end: true,
        });
      }
    } catch (error) {
      if (error instanceof Stripe.errors.StripeError) {
        throw new BadRequestException(`Subscription cancellation failed: ${error.message}`);
      }
      throw new InternalServerErrorException('Subscription cancellation failed');
    }
  }

  /**
   * Update subscription amount
   */
  async updateSubscriptionAmount(
    subscriptionId: string,
    newAmount: number,
    currency: string,
  ): Promise<Stripe.Subscription> {
    try {
      const subscription = await this.stripe.subscriptions.retrieve(subscriptionId);

      if (!subscription.items.data[0]?.price?.recurring) {
        throw new BadRequestException('Subscription does not have recurring pricing');
      }

      // Create new price
      const amountInCents = Math.round(newAmount * 100);
      const price = await this.stripe.prices.create({
        unit_amount: amountInCents,
        currency: currency.toLowerCase(),
        recurring: {
          interval: subscription.items.data[0].price.recurring.interval,
          interval_count: subscription.items.data[0].price.recurring.interval_count || 1,
        },
        product: subscription.items.data[0].price.product as string,
      });

      // Update subscription with new price
      return await this.stripe.subscriptions.update(subscriptionId, {
        items: [
          {
            id: subscription.items.data[0].id,
            price: price.id,
          },
        ],
        proration_behavior: 'none',
      });
    } catch (error) {
      if (error instanceof Stripe.errors.StripeError) {
        throw new BadRequestException(`Subscription update failed: ${error.message}`);
      }
      throw new InternalServerErrorException('Subscription update failed');
    }
  }

  /**
   * Create a refund for a payment
   */
  async createRefund(chargeId: string, amount?: number): Promise<Stripe.Refund> {
    try {
      const refundParams: Stripe.RefundCreateParams = {
        charge: chargeId,
      };

      if (amount) {
        refundParams.amount = Math.round(amount * 100);
      }

      return await this.stripe.refunds.create(refundParams);
    } catch (error) {
      if (error instanceof Stripe.errors.StripeError) {
        throw new BadRequestException(`Refund failed: ${error.message}`);
      }
      throw new InternalServerErrorException('Refund failed');
    }
  }

  /**
   * Verify webhook signature
   */
  verifyWebhookSignature(payload: string | Buffer, signature: string): Stripe.Event {
    const webhookSecret = this.configService.get<string>('STRIPE_WEBHOOK_SECRET');

    if (!webhookSecret) {
      throw new Error('STRIPE_WEBHOOK_SECRET is not configured');
    }

    try {
      return this.stripe.webhooks.constructEvent(payload, signature, webhookSecret);
    } catch (error) {
      throw new BadRequestException('Invalid webhook signature');
    }
  }

  /**
   * Retrieve payment intent by ID
   */
  async getPaymentIntent(paymentIntentId: string): Promise<Stripe.PaymentIntent> {
    try {
      return await this.stripe.paymentIntents.retrieve(paymentIntentId);
    } catch (error) {
      if (error instanceof Stripe.errors.StripeError) {
        throw new BadRequestException(`Payment intent retrieval failed: ${error.message}`);
      }
      throw new InternalServerErrorException('Payment intent retrieval failed');
    }
  }

  /**
   * Retrieve subscription by ID
   */
  async getSubscription(subscriptionId: string): Promise<Stripe.Subscription> {
    try {
      return await this.stripe.subscriptions.retrieve(subscriptionId);
    } catch (error) {
      if (error instanceof Stripe.errors.StripeError) {
        throw new BadRequestException(`Subscription retrieval failed: ${error.message}`);
      }
      throw new InternalServerErrorException('Subscription retrieval failed');
    }
  }

  /**
   * Get upcoming invoice for a subscription (preview next charge)
   */
  async getUpcomingInvoice(customerId: string) {
    try {
      return await this.stripe.invoices.retrieveUpcoming({
        customer: customerId,
      });
    } catch (error) {
      if (error instanceof Stripe.errors.StripeError) {
        throw new BadRequestException(`Invoice retrieval failed: ${error.message}`);
      }
      throw new InternalServerErrorException('Invoice retrieval failed');
    }
  }
}
