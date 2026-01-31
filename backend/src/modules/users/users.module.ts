import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { DatabaseModule } from '@/core/database/database.module';
import { EmailModule } from '@/core/email/email.module';
import { UploadModule } from '@/core/upload/upload.module';

@Module({
  imports: [DatabaseModule, EmailModule, UploadModule],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService],
})
export class UsersModule {}
