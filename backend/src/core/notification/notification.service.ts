import { Injectable, Logger } from '@nestjs/common';

@Injectable()
export class NotificationService {
  private readonly logger = new Logger(NotificationService.name);

  async sendPushNotification(userId: string, title: string, body: string) {
    // TODO: Implement FCM push notification
    this.logger.log(`Push notification to ${userId}: ${title}`);
  }
}
