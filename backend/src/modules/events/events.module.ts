import { Module } from '@nestjs/common';
import { EventsService } from './events.service';
import { EventsController } from './events.controller';
import { DatabaseModule } from '@/core/database/database.module';
import { StripeModule } from '@/core/stripe/stripe.module';
import { EmailModule } from '@/core/email/email.module';

/**
 * Events Module - Handles event management, registration, and QR codes
 */
@Module({
  imports: [DatabaseModule, StripeModule, EmailModule],
  controllers: [EventsController],
  providers: [EventsService],
  exports: [EventsService],
})
export class EventsModule {}
