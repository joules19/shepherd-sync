import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsBoolean } from 'class-validator';

/**
 * DTO for canceling a recurring donation subscription
 */
export class CancelRecurringDonationDto {
  @ApiPropertyOptional({
    description: 'Reason for cancellation',
    example: 'Financial difficulties',
  })
  @IsString()
  @IsOptional()
  cancellationReason?: string;

  @ApiPropertyOptional({
    description: 'Cancel immediately or at end of billing period',
    example: false,
    default: false,
  })
  @IsBoolean()
  @IsOptional()
  cancelImmediately?: boolean;
}
