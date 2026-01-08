import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsEmail } from 'class-validator';

/**
 * DTO for registering for an event
 * For authenticated users, userId is taken from JWT
 * For guest registration, provide guest details
 */
export class RegisterEventDto {
  @ApiPropertyOptional({
    description: 'Child ID if registering a child',
    example: 'uuid',
  })
  @IsString()
  @IsOptional()
  childId?: string;

  @ApiPropertyOptional({
    description: 'Guest name (for non-user registration)',
    example: 'John Doe',
  })
  @IsString()
  @IsOptional()
  guestName?: string;

  @ApiPropertyOptional({
    description: 'Guest email (for non-user registration)',
    example: 'guest@example.com',
  })
  @IsEmail()
  @IsOptional()
  guestEmail?: string;

  @ApiPropertyOptional({
    description: 'Guest phone (for non-user registration)',
    example: '+1234567890',
  })
  @IsString()
  @IsOptional()
  guestPhone?: string;

  @ApiPropertyOptional({
    description: 'Stripe Payment Method ID (optional - payment can be made later if not provided)',
    example: 'pm_1234567890',
  })
  @IsString()
  @IsOptional()
  stripePaymentMethodId?: string;
}
