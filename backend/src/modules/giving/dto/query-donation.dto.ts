import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsEnum, IsDateString, IsString, IsBoolean, IsIn } from 'class-validator';
import { Type } from 'class-transformer';
import { DonationType, PaymentMethod, PaymentStatus } from '@prisma/client';

/**
 * DTO for querying and filtering donations with pagination
 */
export class QueryDonationDto {
  @ApiPropertyOptional({
    description: 'Page number',
    example: 1,
    default: 1,
  })
  @IsOptional()
  @Type(() => Number)
  page?: number;

  @ApiPropertyOptional({
    description: 'Items per page',
    example: 20,
    default: 20,
  })
  @IsOptional()
  @Type(() => Number)
  limit?: number;

  @ApiPropertyOptional({
    description: 'Search by donor name or email',
    example: 'john',
  })
  @IsString()
  @IsOptional()
  search?: string;

  @ApiPropertyOptional({
    description: 'Filter by donation type',
    enum: DonationType,
    example: DonationType.TITHE,
  })
  @IsEnum(DonationType)
  @IsOptional()
  donationType?: DonationType;

  @ApiPropertyOptional({
    description: 'Filter by payment method',
    enum: PaymentMethod,
    example: PaymentMethod.CREDIT_CARD,
  })
  @IsEnum(PaymentMethod)
  @IsOptional()
  paymentMethod?: PaymentMethod;

  @ApiPropertyOptional({
    description: 'Filter by payment status',
    enum: PaymentStatus,
    example: PaymentStatus.COMPLETED,
  })
  @IsEnum(PaymentStatus)
  @IsOptional()
  paymentStatus?: PaymentStatus;

  @ApiPropertyOptional({
    description: 'Filter by recurring donations only',
    example: false,
  })
  @IsBoolean()
  @IsOptional()
  @Type(() => Boolean)
  isRecurring?: boolean;

  @ApiPropertyOptional({
    description: 'Filter by anonymous donations only',
    example: false,
  })
  @IsBoolean()
  @IsOptional()
  @Type(() => Boolean)
  isAnonymous?: boolean;

  @ApiPropertyOptional({
    description: 'Filter donations created after this date (ISO 8601)',
    example: '2026-01-01',
  })
  @IsDateString()
  @IsOptional()
  createdAfter?: string;

  @ApiPropertyOptional({
    description: 'Filter donations created before this date (ISO 8601)',
    example: '2026-12-31',
  })
  @IsDateString()
  @IsOptional()
  createdBefore?: string;

  @ApiPropertyOptional({
    description: 'Filter by user ID (authenticated donor)',
    example: 'uuid',
  })
  @IsString()
  @IsOptional()
  userId?: string;

  @ApiPropertyOptional({
    description: 'Sort field',
    example: 'createdAt',
    default: 'createdAt',
    enum: ['createdAt', 'amount', 'donationType', 'paymentStatus'],
  })
  @IsOptional()
  @IsIn(['createdAt', 'amount', 'donationType', 'paymentStatus'])
  sortBy?: string;

  @ApiPropertyOptional({
    description: 'Sort order',
    example: 'desc',
    default: 'desc',
    enum: ['asc', 'desc'],
  })
  @IsOptional()
  @IsIn(['asc', 'desc'])
  sortOrder?: 'asc' | 'desc';
}
