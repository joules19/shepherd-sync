import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsObject, IsString } from 'class-validator';

/**
 * DTO for Stripe webhook events
 * Stripe sends webhook events when payment status changes
 */
export class StripeWebhookDto {
  @ApiProperty({
    description: 'Stripe event ID',
    example: 'evt_1234567890',
  })
  @IsString()
  @IsNotEmpty()
  id: string;

  @ApiProperty({
    description: 'Stripe event type',
    example: 'payment_intent.succeeded',
  })
  @IsString()
  @IsNotEmpty()
  type: string;

  @ApiProperty({
    description: 'Stripe event data object',
  })
  @IsObject()
  @IsNotEmpty()
  data: {
    object: any;
  };
}

/**
 * Supported Stripe webhook event types
 */
export enum StripeEventType {
  // One-time payment events
  PAYMENT_INTENT_SUCCEEDED = 'payment_intent.succeeded',
  PAYMENT_INTENT_FAILED = 'payment_intent.payment_failed',
  PAYMENT_INTENT_CANCELED = 'payment_intent.canceled',

  // Subscription/recurring events
  INVOICE_PAYMENT_SUCCEEDED = 'invoice.payment_succeeded',
  INVOICE_PAYMENT_FAILED = 'invoice.payment_failed',
  CUSTOMER_SUBSCRIPTION_CREATED = 'customer.subscription.created',
  CUSTOMER_SUBSCRIPTION_UPDATED = 'customer.subscription.updated',
  CUSTOMER_SUBSCRIPTION_DELETED = 'customer.subscription.deleted',

  // Refund events
  CHARGE_REFUNDED = 'charge.refunded',
}
