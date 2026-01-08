import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsOptional, IsObject } from 'class-validator';

export class UpdateOrganizationSettingsDto {
  @ApiPropertyOptional({ example: 'custom.church.com' })
  @IsString()
  @IsOptional()
  customDomain?: string;

  @ApiPropertyOptional({ example: '#3B82F6' })
  @IsString()
  @IsOptional()
  primaryColor?: string;

  @ApiPropertyOptional({ example: '#10B981' })
  @IsString()
  @IsOptional()
  secondaryColor?: string;

  @ApiPropertyOptional({
    example: { emailNotifications: true, smsEnabled: false, defaultEventReminder: 24 },
    description: 'Custom JSON settings for the organization',
  })
  @IsObject()
  @IsOptional()
  settings?: Record<string, any>;
}
