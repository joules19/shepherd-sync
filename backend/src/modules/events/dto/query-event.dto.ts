import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsEnum, IsDateString, IsString, IsBoolean, IsIn } from 'class-validator';
import { Type } from 'class-transformer';
import { EventType, EventStatus } from '@prisma/client';

/**
 * DTO for querying and filtering events with pagination
 */
export class QueryEventDto {
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
    description: 'Search by event title or description',
    example: 'worship',
  })
  @IsString()
  @IsOptional()
  search?: string;

  @ApiPropertyOptional({
    description: 'Filter by event type',
    enum: EventType,
    example: EventType.SERVICE,
  })
  @IsEnum(EventType)
  @IsOptional()
  eventType?: EventType;

  @ApiPropertyOptional({
    description: 'Filter by event status',
    enum: EventStatus,
    example: EventStatus.PUBLISHED,
  })
  @IsEnum(EventStatus)
  @IsOptional()
  status?: EventStatus;

  @ApiPropertyOptional({
    description: 'Filter events starting after this date (ISO 8601)',
    example: '2026-01-01',
  })
  @IsDateString()
  @IsOptional()
  startAfter?: string;

  @ApiPropertyOptional({
    description: 'Filter events starting before this date (ISO 8601)',
    example: '2026-12-31',
  })
  @IsDateString()
  @IsOptional()
  startBefore?: string;

  @ApiPropertyOptional({
    description: 'Filter by virtual events only',
    example: false,
  })
  @IsBoolean()
  @IsOptional()
  @Type(() => Boolean)
  isVirtual?: boolean;

  @ApiPropertyOptional({
    description: 'Filter by events requiring registration',
    example: true,
  })
  @IsBoolean()
  @IsOptional()
  @Type(() => Boolean)
  requiresRegistration?: boolean;

  @ApiPropertyOptional({
    description: 'Filter by public/private events',
    example: true,
  })
  @IsBoolean()
  @IsOptional()
  @Type(() => Boolean)
  isPublic?: boolean;

  @ApiPropertyOptional({
    description: 'Sort field',
    example: 'startDate',
    default: 'startDate',
    enum: ['startDate', 'createdAt', 'title', 'eventType'],
  })
  @IsOptional()
  @IsIn(['startDate', 'createdAt', 'title', 'eventType'])
  sortBy?: string;

  @ApiPropertyOptional({
    description: 'Sort order',
    example: 'asc',
    default: 'asc',
    enum: ['asc', 'desc'],
  })
  @IsOptional()
  @IsIn(['asc', 'desc'])
  sortOrder?: 'asc' | 'desc';
}
