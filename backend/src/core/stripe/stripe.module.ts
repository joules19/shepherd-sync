import { Module, Global } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { StripeService } from './stripe.service';

/**
 * Stripe Module - Global module for payment processing
 * Provides Stripe service for donations and subscriptions
 */
@Global()
@Module({
  imports: [ConfigModule],
  providers: [StripeService],
  exports: [StripeService],
})
export class StripeModule {}
