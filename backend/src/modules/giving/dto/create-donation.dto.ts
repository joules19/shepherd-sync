import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsEnum,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  IsEmail,
  IsBoolean,
  Min,
  Max,
  Matches,
} from 'class-validator';
import { DonationType, PaymentMethod } from '@prisma/client';

/**
 * DTO for creating a one-time donation
 */
export class CreateDonationDto {
  @ApiProperty({
    description: 'Donation amount in the organization currency',
    example: 100.0,
    minimum: 1,
    maximum: 999999,
  })
  @IsNumber({ maxDecimalPlaces: 2 })
  @Min(1, { message: 'Minimum donation amount is $1' })
  @Max(999999, { message: 'Maximum donation amount is $999,999' })
  @IsNotEmpty()
  amount: number;

  @ApiPropertyOptional({
    description: 'Currency code (ISO 4217)',
    example: 'USD',
    default: 'USD',
  })
  @IsString()
  @IsOptional()
  @Matches(/^[A-Z]{3}$/, { message: 'Currency must be a valid 3-letter code' })
  currency?: string;

  @ApiProperty({
    description: 'Type of donation',
    enum: DonationType,
    example: DonationType.TITHE,
  })
  @IsEnum(DonationType)
  @IsNotEmpty()
  donationType: DonationType;

  @ApiProperty({
    description: 'Payment method',
    enum: PaymentMethod,
    example: PaymentMethod.CREDIT_CARD,
  })
  @IsEnum(PaymentMethod)
  @IsNotEmpty()
  paymentMethod: PaymentMethod;

  @ApiPropertyOptional({
    description: 'Donor name (for anonymous or guest donations)',
    example: 'John Doe',
  })
  @IsString()
  @IsOptional()
  donorName?: string;

  @ApiPropertyOptional({
    description: 'Donor email (for anonymous or guest donations)',
    example: 'john@example.com',
  })
  @IsEmail()
  @IsOptional()
  donorEmail?: string;

  @ApiPropertyOptional({
    description: 'Donor phone (for anonymous or guest donations)',
    example: '+1234567890',
  })
  @IsString()
  @IsOptional()
  donorPhone?: string;

  @ApiPropertyOptional({
    description: 'Additional notes or comments',
    example: 'In memory of...',
  })
  @IsString()
  @IsOptional()
  notes?: string;

  @ApiPropertyOptional({
    description: 'Whether donation should be anonymous',
    example: false,
    default: false,
  })
  @IsBoolean()
  @IsOptional()
  isAnonymous?: boolean;

  @ApiProperty({
    description: 'Stripe Payment Method ID (from Stripe.js)',
    example: 'pm_1234567890',
  })
  @IsString()
  @IsNotEmpty()
  stripePaymentMethodId: string;
}
