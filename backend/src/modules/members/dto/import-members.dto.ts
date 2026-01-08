import { ApiProperty } from '@nestjs/swagger';
import { IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { CreateMemberDto } from './create-member.dto';

export class ImportMembersDto {
  @ApiProperty({
    type: [CreateMemberDto],
    description: 'Array of members to import',
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateMemberDto)
  members: CreateMemberDto[];
}

export class ImportResultDto {
  success: boolean;
  imported: number;
  failed: number;
  errors?: Array<{
    row: number;
    email?: string;
    name?: string;
    error: string;
  }>;
}
