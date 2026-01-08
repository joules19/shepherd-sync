import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  constructor() {
    super({
      log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
    });
  }

  async onModuleInit() {
    await this.$connect();
    console.log('✅ Database connected');
  }

  async onModuleDestroy() {
    await this.$disconnect();
    console.log('❌ Database disconnected');
  }

  // Helper method for soft deletes
  async softDelete(model: any, where: any) {
    return model.update({
      where,
      data: { deletedAt: new Date() },
    });
  }

  // Helper method to restore soft deleted records
  async restore(model: any, where: any) {
    return model.update({
      where,
      data: { deletedAt: null },
    });
  }

  // Clean response (exclude sensitive fields)
  exclude<T, Key extends keyof T>(entity: T, keys: Key[]): Omit<T, Key> {
    const result = { ...entity };
    for (const key of keys) {
      delete result[key];
    }
    return result;
  }
}
