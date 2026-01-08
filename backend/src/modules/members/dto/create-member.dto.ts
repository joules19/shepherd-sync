import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsNotEmpty,
  IsEmail,
  IsEnum,
  IsOptional,
  IsDateString,
  IsObject,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { Gender, MembershipStatus, MaritalStatus } from '@prisma/client';

class AddressDto {
  @ApiPropertyOptional({ example: '123 Main St' })
  @IsString()
  @IsOptional()
  street?: string;

  @ApiPropertyOptional({ example: 'Springfield' })
  @IsString()
  @IsOptional()
  city?: string;

  @ApiPropertyOptional({ example: 'IL' })
  @IsString()
  @IsOptional()
  state?: string;

  @ApiPropertyOptional({ example: '62701' })
  @IsString()
  @IsOptional()
  zip?: string;

  @ApiPropertyOptional({ example: 'USA' })
  @IsString()
  @IsOptional()
  country?: string;
}

class EmergencyContactDto {
  @ApiPropertyOptional({ example: 'Jane Doe' })
  @IsString()
  @IsOptional()
  name?: string;

  @ApiPropertyOptional({ example: 'Spouse' })
  @IsString()
  @IsOptional()
  relationship?: string;

  @ApiPropertyOptional({ example: '+1234567890' })
  @IsString()
  @IsOptional()
  phone?: string;
}

export class CreateMemberDto {
  @ApiProperty({ example: 'John' })
  @IsString()
  @IsNotEmpty()
  firstName: string;

  @ApiProperty({ example: 'Doe' })
  @IsString()
  @IsNotEmpty()
  lastName: string;

  @ApiPropertyOptional({ example: 'john.doe@email.com' })
  @IsEmail()
  @IsOptional()
  email?: string;

  @ApiPropertyOptional({ example: '+1234567890' })
  @IsString()
  @IsOptional()
  phone?: string;

  @ApiPropertyOptional({ example: '1990-01-15' })
  @IsDateString()
  @IsOptional()
  dateOfBirth?: string;

  @ApiPropertyOptional({ enum: Gender, example: Gender.MALE })
  @IsEnum(Gender)
  @IsOptional()
  gender?: Gender;

  @ApiPropertyOptional({ type: AddressDto })
  @ValidateNested()
  @Type(() => AddressDto)
  @IsOptional()
  address?: AddressDto;

  @ApiPropertyOptional({ example: 'https://cloudinary.com/photo.png' })
  @IsString()
  @IsOptional()
  photo?: string;

  @ApiPropertyOptional({
    enum: MembershipStatus,
    example: MembershipStatus.ACTIVE_MEMBER,
    default: MembershipStatus.VISITOR,
  })
  @IsEnum(MembershipStatus)
  @IsOptional()
  membershipStatus?: MembershipStatus;

  @ApiPropertyOptional({ example: '2024-01-01' })
  @IsDateString()
  @IsOptional()
  joinedDate?: string;

  @ApiPropertyOptional({ example: '2023-06-15' })
  @IsDateString()
  @IsOptional()
  baptismDate?: string;

  @ApiPropertyOptional({ enum: MaritalStatus, example: MaritalStatus.MARRIED })
  @IsEnum(MaritalStatus)
  @IsOptional()
  maritalStatus?: MaritalStatus;

  @ApiPropertyOptional({ example: 'Software Engineer' })
  @IsString()
  @IsOptional()
  occupation?: string;

  @ApiPropertyOptional({
    type: 'object',
    example: { ministry: 'Worship Team', skills: 'Guitar, Vocals' },
    description: 'Custom fields specific to your church',
  })
  @IsObject()
  @IsOptional()
  customFields?: Record<string, any>;

  @ApiPropertyOptional({ type: EmergencyContactDto })
  @ValidateNested()
  @Type(() => EmergencyContactDto)
  @IsOptional()
  emergencyContact?: EmergencyContactDto;

  @ApiPropertyOptional({
    example: 'user-uuid-if-linked',
    description: 'Link to User account if member has system login',
  })
  @IsString()
  @IsOptional()
  userId?: string;
}
