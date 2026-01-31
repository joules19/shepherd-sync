import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsNotEmpty, IsOptional, MinLength } from 'class-validator';

export class CompleteInviteDto {
  @ApiProperty({ example: 'abc123xyz-token' })
  @IsString()
  @IsNotEmpty()
  token: string;

  @ApiPropertyOptional({
    example: 'SecurePassword123!',
    description: 'Password for new account (optional if using OAuth)',
  })
  @IsString()
  @MinLength(8)
  @IsOptional()
  password?: string;

  @ApiPropertyOptional({
    example: 'google-id-token',
    description: 'Google OAuth ID token',
  })
  @IsString()
  @IsOptional()
  googleIdToken?: string;

  @ApiPropertyOptional({
    example: 'apple-auth-code',
    description: 'Apple OAuth authorization code',
  })
  @IsString()
  @IsOptional()
  appleAuthCode?: string;

  @ApiPropertyOptional({
    example: 'data:image/jpeg;base64,...',
    description: 'Base64 encoded profile photo',
  })
  @IsString()
  @IsOptional()
  profilePhotoBase64?: string;
}
