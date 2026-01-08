import { Module } from '@nestjs/common';
import { DonationsService } from './donations.service';
import { DonationsController } from './donations.controller';
import { DatabaseModule } from '@/core/database/database.module';
import { StripeModule } from '@/core/stripe/stripe.module';
import { EmailModule } from '@/core/email/email.module';

/**
 * Giving Module - Handles donations and payment processing
 * Integrates with Stripe for payments and Postmark for receipts
 */
@Module({
  imports: [DatabaseModule, StripeModule, EmailModule],
  controllers: [DonationsController],
  providers: [DonationsService],
  exports: [DonationsService],
})
export class GivingModule {}
