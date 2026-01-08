import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsNotEmpty, Matches, IsOptional, IsEnum } from 'class-validator';

export class CreateOrganizationDto {
  @ApiProperty({ example: 'First Baptist Church' })
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiProperty({ example: 'firstbaptist', description: 'Unique subdomain for the organization' })
  @IsString()
  @IsNotEmpty()
  @Matches(/^[a-z0-9-]+$/, {
    message: 'Subdomain can only contain lowercase letters, numbers, and hyphens',
  })
  subdomain: string;

  @ApiPropertyOptional({ example: 'America/New_York' })
  @IsString()
  @IsOptional()
  timezone?: string;

  @ApiPropertyOptional({ example: 'USD' })
  @IsString()
  @IsOptional()
  currency?: string;

  @ApiPropertyOptional({ example: 'https://cloudinary.com/logo.png' })
  @IsString()
  @IsOptional()
  logo?: string;
}
