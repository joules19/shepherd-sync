import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as postmark from 'postmark';

@Injectable()
export class EmailService {
  private readonly logger = new Logger(EmailService.name);
  private client: postmark.ServerClient;

  constructor(private configService: ConfigService) {
    const apiKey = this.configService.get('POSTMARK_API_KEY');
    if (apiKey) {
      this.client = new postmark.ServerClient(apiKey);
    } else {
      this.logger.warn('Postmark API key not configured');
    }
  }

  async sendTransactional(to: string, templateId: string, data: any) {
    if (!this.client) {
      this.logger.warn(`Email not sent (Postmark not configured): ${to}`);
      return;
    }

    try {
      const result = await this.client.sendEmailWithTemplate({
        From: this.configService.get('POSTMARK_FROM_EMAIL') || 'noreply@example.com',
        To: to,
        TemplateAlias: templateId,
        TemplateModel: data,
      });

      this.logger.log(`Email sent to ${to}: ${result.Message}`);
      return result;
    } catch (error) {
      this.logger.error(`Failed to send email to ${to}:`, error);
      throw error;
    }
  }

  async sendBulk(emails: Array<{ to: string; data: any }>, templateId: string) {
    if (!this.client) {
      this.logger.warn('Bulk email not sent (Postmark not configured)');
      return;
    }

    const messages = emails.map((email) => ({
      From: this.configService.get('POSTMARK_FROM_EMAIL') || 'noreply@example.com',
      To: email.to,
      TemplateAlias: templateId,
      TemplateModel: email.data,
    }));

    try {
      const result = await this.client.sendEmailBatchWithTemplates(messages);
      this.logger.log(`Bulk email sent to ${emails.length} recipients`);
      return result;
    } catch (error) {
      this.logger.error('Failed to send bulk email:', error);
      throw error;
    }
  }
}
