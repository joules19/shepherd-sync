import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsOptional, IsEnum, IsDateString } from 'class-validator';
import { Type } from 'class-transformer';
import { PaginationDto } from '@/common/types/pagination.interface';
import { Gender, MembershipStatus, MaritalStatus } from '@prisma/client';

export class QueryMemberDto extends PaginationDto {
  @ApiPropertyOptional({ example: 'John' })
  @IsString()
  @IsOptional()
  search?: string;

  @ApiPropertyOptional({ enum: Gender })
  @IsEnum(Gender)
  @IsOptional()
  gender?: Gender;

  @ApiPropertyOptional({ enum: MembershipStatus })
  @IsEnum(MembershipStatus)
  @IsOptional()
  membershipStatus?: MembershipStatus;

  @ApiPropertyOptional({ enum: MaritalStatus })
  @IsEnum(MaritalStatus)
  @IsOptional()
  maritalStatus?: MaritalStatus;

  @ApiPropertyOptional({ example: '2024-01-01' })
  @IsDateString()
  @IsOptional()
  joinedAfter?: string;

  @ApiPropertyOptional({ example: '2024-12-31' })
  @IsDateString()
  @IsOptional()
  joinedBefore?: string;

  @ApiPropertyOptional({
    example: 'firstName',
    description: 'Sort by field: firstName, lastName, joinedDate, dateOfBirth',
  })
  @IsString()
  @IsOptional()
  sortBy?: string;

  @ApiPropertyOptional({
    example: 'asc',
    description: 'Sort order: asc or desc',
  })
  @IsString()
  @IsOptional()
  sortOrder?: 'asc' | 'desc';
}
