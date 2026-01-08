import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsBoolean } from 'class-validator';

/**
 * DTO for updating donation metadata (not payment details)
 * Only notes and anonymous flag can be updated after creation
 */
export class UpdateDonationDto {
  @ApiPropertyOptional({
    description: 'Additional notes or comments',
    example: 'Updated note',
  })
  @IsString()
  @IsOptional()
  notes?: string;

  @ApiPropertyOptional({
    description: 'Whether donation should be anonymous',
    example: false,
  })
  @IsBoolean()
  @IsOptional()
  isAnonymous?: boolean;
}
