import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsOptional, IsEnum, IsBoolean } from 'class-validator';
import { Type } from 'class-transformer';
import { PaginationDto } from '@/common/types/pagination.interface';
import { PlanType, SubscriptionStatus } from '@prisma/client';

export class QueryOrganizationDto extends PaginationDto {
  @ApiPropertyOptional({ example: 'Baptist' })
  @IsString()
  @IsOptional()
  search?: string;

  @ApiPropertyOptional({ enum: PlanType })
  @IsEnum(PlanType)
  @IsOptional()
  planType?: PlanType;

  @ApiPropertyOptional({ enum: SubscriptionStatus })
  @IsEnum(SubscriptionStatus)
  @IsOptional()
  subscriptionStatus?: SubscriptionStatus;

  @ApiPropertyOptional({ example: true })
  @IsBoolean()
  @Type(() => Boolean)
  @IsOptional()
  isActive?: boolean;
}
