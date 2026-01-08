import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsNotEmpty,
  IsEnum,
  IsDateString,
  IsBoolean,
  IsOptional,
  IsNumber,
  IsArray,
  Min,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { EventType, EventStatus, AgeGroup, UserRole } from '@prisma/client';

class AddressDto {
  @ApiPropertyOptional({ description: 'Street address' })
  @IsString()
  @IsOptional()
  street?: string;

  @ApiPropertyOptional({ description: 'City' })
  @IsString()
  @IsOptional()
  city?: string;

  @ApiPropertyOptional({ description: 'State/Province' })
  @IsString()
  @IsOptional()
  state?: string;

  @ApiPropertyOptional({ description: 'Postal code' })
  @IsString()
  @IsOptional()
  zip?: string;

  @ApiPropertyOptional({ description: 'Country' })
  @IsString()
  @IsOptional()
  country?: string;
}

/**
 * DTO for creating an event
 */
export class CreateEventDto {
  @ApiProperty({
    description: 'Event title',
    example: 'Sunday Worship Service',
  })
  @IsString()
  @IsNotEmpty()
  title: string;

  @ApiPropertyOptional({
    description: 'Event description',
    example: 'Join us for our weekly worship service',
  })
  @IsString()
  @IsOptional()
  description?: string;

  @ApiProperty({
    description: 'Type of event',
    enum: EventType,
    example: EventType.SERVICE,
  })
  @IsEnum(EventType)
  @IsNotEmpty()
  eventType: EventType;

  @ApiProperty({
    description: 'Event start date and time (ISO 8601)',
    example: '2026-01-12T10:00:00Z',
  })
  @IsDateString()
  @IsNotEmpty()
  startDate: string;

  @ApiProperty({
    description: 'Event end date and time (ISO 8601)',
    example: '2026-01-12T12:00:00Z',
  })
  @IsDateString()
  @IsNotEmpty()
  endDate: string;

  @ApiPropertyOptional({
    description: 'Timezone (IANA timezone)',
    example: 'America/New_York',
  })
  @IsString()
  @IsOptional()
  timezone?: string;

  @ApiPropertyOptional({
    description: 'Event location name',
    example: 'Main Sanctuary',
  })
  @IsString()
  @IsOptional()
  location?: string;

  @ApiPropertyOptional({
    description: 'Physical address of event',
    type: AddressDto,
  })
  @ValidateNested()
  @Type(() => AddressDto)
  @IsOptional()
  address?: AddressDto;

  @ApiPropertyOptional({
    description: 'Is this a virtual event?',
    example: false,
    default: false,
  })
  @IsBoolean()
  @IsOptional()
  isVirtual?: boolean;

  @ApiPropertyOptional({
    description: 'Virtual event link (for online events)',
    example: 'https://zoom.us/j/123456789',
  })
  @IsString()
  @IsOptional()
  virtualLink?: string;

  @ApiPropertyOptional({
    description: 'Does this event require registration?',
    example: true,
    default: false,
  })
  @IsBoolean()
  @IsOptional()
  requiresRegistration?: boolean;

  @ApiPropertyOptional({
    description: 'Maximum number of attendees',
    example: 100,
  })
  @IsNumber()
  @Min(1)
  @IsOptional()
  maxAttendees?: number;

  @ApiPropertyOptional({
    description: 'Registration deadline (ISO 8601)',
    example: '2026-01-11T23:59:59Z',
  })
  @IsDateString()
  @IsOptional()
  registrationDeadline?: string;

  @ApiPropertyOptional({
    description: 'Registration fee amount',
    example: 25.0,
  })
  @IsNumber({ maxDecimalPlaces: 2 })
  @Min(0)
  @IsOptional()
  registrationFee?: number;

  @ApiPropertyOptional({
    description: 'Cover image URL',
    example: 'https://example.com/image.jpg',
  })
  @IsString()
  @IsOptional()
  coverImage?: string;

  @ApiPropertyOptional({
    description: 'Is this event public (visible to non-members)?',
    example: true,
    default: true,
  })
  @IsBoolean()
  @IsOptional()
  isPublic?: boolean;

  @ApiPropertyOptional({
    description: 'Target age groups for this event',
    enum: AgeGroup,
    isArray: true,
    example: [AgeGroup.CHILDREN_0_12],
  })
  @IsArray()
  @IsEnum(AgeGroup, { each: true })
  @IsOptional()
  targetAgeGroups?: AgeGroup[];

  @ApiPropertyOptional({
    description: 'Target user roles for this event',
    enum: UserRole,
    isArray: true,
    example: [UserRole.MEMBER],
  })
  @IsArray()
  @IsEnum(UserRole, { each: true })
  @IsOptional()
  targetRoles?: UserRole[];

  @ApiPropertyOptional({
    description: 'Event status',
    enum: EventStatus,
    example: EventStatus.DRAFT,
    default: EventStatus.DRAFT,
  })
  @IsEnum(EventStatus)
  @IsOptional()
  status?: EventStatus;
}
