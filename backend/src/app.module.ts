import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ThrottlerModule } from '@nestjs/throttler';
import { BullModule } from '@nestjs/bull';
import { EventEmitterModule } from '@nestjs/event-emitter';
import { ScheduleModule } from '@nestjs/schedule';

// Core modules
import { DatabaseModule } from './core/database/database.module';
import { AuthModule } from './core/auth/auth.module';
import { EmailModule } from './core/email/email.module';
import { UploadModule } from './core/upload/upload.module';
import { NotificationModule } from './core/notification/notification.module';
import { QueueModule } from './core/queue/queue.module';
import { StripeModule } from './core/stripe/stripe.module';

// Business modules
import { OrganizationsModule } from './modules/organizations/organizations.module';
import { UsersModule } from './modules/users/users.module';
import { MembersModule } from './modules/members/members.module';
import { GivingModule } from './modules/giving/giving.module';
import { EventsModule } from './modules/events/events.module';
// TODO: Uncomment as modules are implemented
// import { ChildrenModule } from './modules/children/children.module';
// import { AttendanceModule } from './modules/attendance/attendance.module';
// import { MediaModule } from './modules/media/media.module';
// import { CommunicationsModule } from './modules/communications/communications.module';
// import { GroupsModule } from './modules/groups/groups.module';
// import { AnalyticsModule } from './modules/analytics/analytics.module';
// import { SubscriptionsModule } from './modules/subscriptions/subscriptions.module';
// import { SuperAdminModule } from './modules/super-admin/super-admin.module';

@Module({
  imports: [
    // Configuration
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),

    // Throttling (Rate limiting)
    ThrottlerModule.forRoot([
      {
        ttl: parseInt(process.env.THROTTLE_TTL || '60', 10) * 1000,
        limit: parseInt(process.env.THROTTLE_LIMIT || '100', 10),
      },
    ]),

    // Bull (Queue management)
    BullModule.forRoot({
      redis: {
        host: process.env.REDIS_HOST || 'localhost',
        port: parseInt(process.env.REDIS_PORT || '6379', 10),
        password: process.env.REDIS_PASSWORD,
      },
    }),

    // Event Emitter
    EventEmitterModule.forRoot(),

    // Schedule (Cron jobs)
    ScheduleModule.forRoot(),

    // Core Modules
    DatabaseModule,
    AuthModule,
    EmailModule,
    UploadModule,
    NotificationModule,
    QueueModule,
    StripeModule,

    // Business Modules
    OrganizationsModule,
    UsersModule,
    MembersModule,
    GivingModule,
    EventsModule,
    // TODO: Uncomment as modules are implemented
    // ChildrenModule,
    // AttendanceModule,
    // MediaModule,
    // CommunicationsModule,
    // GroupsModule,
    // AnalyticsModule,
    // SubscriptionsModule,
    // SuperAdminModule,
  ],
})
export class AppModule {}
