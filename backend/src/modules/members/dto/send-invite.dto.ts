import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsOptional, IsString } from 'class-validator';

export enum InviteMethod {
  SMS = 'SMS',
  EMAIL = 'EMAIL',
  WHATSAPP = 'WHATSAPP',
  MANUAL = 'MANUAL',
}

export class SendInviteDto {
  @ApiProperty({ enum: InviteMethod, example: InviteMethod.SMS })
  @IsEnum(InviteMethod)
  method: InviteMethod;

  @ApiPropertyOptional({
    example: 'Welcome to Grace Church! Complete your profile to get started.',
  })
  @IsString()
  @IsOptional()
  customMessage?: string;
}
