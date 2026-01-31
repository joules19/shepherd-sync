import { Module } from '@nestjs/common';
import { MembersService } from './members.service';
import { MembersController } from './members.controller';
import { DatabaseModule } from '@/core/database/database.module';
import { EmailModule } from '@/core/email/email.module';
import { UploadModule } from '@/core/upload/upload.module';

@Module({
  imports: [DatabaseModule, EmailModule, UploadModule],
  controllers: [MembersController],
  providers: [MembersService],
  exports: [MembersService],
})
export class MembersModule {}
