import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as postmark from 'postmark';
import * as fs from 'fs';
import * as path from 'path';

@Injectable()
export class EmailService {
  private readonly logger = new Logger(EmailService.name);
  private client: postmark.ServerClient;
  private templatesPath: string;

  constructor(private configService: ConfigService) {
    const apiKey = this.configService.get('POSTMARK_API_KEY');
    if (apiKey) {
      this.client = new postmark.ServerClient(apiKey);
    } else {
      this.logger.warn('Postmark API key not configured');
    }

    // Path to email templates directory
    // In development: backend/email-templates
    // In production: backend/email-templates (copied during build)
    // Use process.cwd() to get project root, not __dirname which points to dist folder
    this.templatesPath = path.join(process.cwd(), 'email-templates');
  }

  /**
   * Load HTML template from file and replace variables
   */
  private loadTemplate(templateName: string, variables: Record<string, any>): string {
    try {
      const templatePath = path.join(this.templatesPath, `${templateName}.html`);
      let html = fs.readFileSync(templatePath, 'utf-8');

      // Replace all {{VARIABLE}} placeholders with actual values
      Object.keys(variables).forEach((key) => {
        const regex = new RegExp(`{{${key}}}`, 'g');
        html = html.replace(regex, variables[key] || '');
      });

      return html;
    } catch (error) {
      this.logger.error(`Failed to load template ${templateName}:`, error);
      throw error;
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

  async sendMemberInviteEmail(data: {
    to: string;
    memberFirstName: string;
    churchName: string;
    inviteUrl: string;
    inviteCode: string;
    expirationDate: string;
    churchLogoUrl?: string;
  }) {
    if (!this.client) {
      this.logger.warn(`Invite email not sent (Postmark not configured): ${data.to}`);
      this.logger.log(`[EMAIL] Would send to ${data.to} with code: ${data.inviteCode}`);
      return;
    }

    try {
      // Load and process HTML template from local file
      const htmlBody = this.loadTemplate('member-invite', {
        CHURCH_NAME: data.churchName,
        CHURCH_LOGO_URL: data.churchLogoUrl || '',
        MEMBER_FIRST_NAME: data.memberFirstName,
        INVITE_URL: data.inviteUrl,
        INVITE_CODE: data.inviteCode,
        EXPIRATION_DATE: data.expirationDate,
      });

      // Send email with inline HTML (no Postmark template required)
      const result = await this.client.sendEmail({
        From: this.configService.get('POSTMARK_FROM_EMAIL') || 'noreply@shepherdsync.com',
        To: data.to,
        Subject: `You're Invited to ${data.churchName}!`,
        HtmlBody: htmlBody,
        TextBody: `Hi ${data.memberFirstName},

You've been invited to join ${data.churchName} on Shepherd Sync!

Click here to accept: ${data.inviteUrl}

Or enter this code in the app: ${data.inviteCode}

⏰ Important: This invite expires on ${data.expirationDate}.

---
Sent by ${data.churchName}
Powered by Shepherd Sync - Church Management Made Simple`,
        MessageStream: 'outbound',
      });

      this.logger.log(`Member invite email sent to ${data.to} (Code: ${data.inviteCode})`);
      return result;
    } catch (error) {
      this.logger.error(`Failed to send member invite email to ${data.to}:`, error);
      throw error;
    }
  }
}
