import { Injectable } from '@nestjs/common';
import { PrismaService } from './prisma.service';

/**
 * TenantService provides helper methods for multi-tenant operations
 * Ensures all queries are automatically scoped to the correct organization
 */
@Injectable()
export class TenantService {
  constructor(private prisma: PrismaService) {}

  /**
   * Get a scoped Prisma client for a specific organization
   * All queries will automatically include organizationId filter
   */
  forOrganization(organizationId: string) {
    return {
      // Members
      members: {
        findMany: (args: any = {}) =>
          this.prisma.member.findMany({
            ...args,
            where: { ...args.where, organizationId, deletedAt: null },
          }),
        findFirst: (args: any = {}) =>
          this.prisma.member.findFirst({
            ...args,
            where: { ...args.where, organizationId, deletedAt: null },
          }),
        findUnique: (args: any) =>
          this.prisma.member.findFirst({
            where: { ...args.where, organizationId, deletedAt: null },
          }),
        create: (args: any) =>
          this.prisma.member.create({
            ...args,
            data: { ...args.data, organizationId },
          }),
        update: (args: any) =>
          this.prisma.member.update({
            ...args,
            where: { ...args.where, organizationId },
          }),
        delete: (args: any) =>
          this.prisma.member.update({
            where: { ...args.where, organizationId },
            data: { deletedAt: new Date() },
          }),
        count: (args: any = {}) =>
          this.prisma.member.count({
            ...args,
            where: { ...args.where, organizationId, deletedAt: null },
          }),
      },

      // Users
      users: {
        findMany: (args: any = {}) =>
          this.prisma.user.findMany({
            ...args,
            where: { ...args.where, organizationId },
          }),
        findFirst: (args: any = {}) =>
          this.prisma.user.findFirst({
            ...args,
            where: { ...args.where, organizationId },
          }),
        create: (args: any) =>
          this.prisma.user.create({
            ...args,
            data: { ...args.data, organizationId },
          }),
        update: (args: any) =>
          this.prisma.user.update({
            ...args,
            where: { ...args.where, organizationId },
          }),
        count: (args: any = {}) =>
          this.prisma.user.count({
            ...args,
            where: { ...args.where, organizationId },
          }),
      },

      // Donations
      donations: {
        findMany: (args: any = {}) =>
          this.prisma.donation.findMany({
            ...args,
            where: { ...args.where, organizationId },
          }),
        findFirst: (args: any = {}) =>
          this.prisma.donation.findFirst({
            ...args,
            where: { ...args.where, organizationId },
          }),
        create: (args: any) =>
          this.prisma.donation.create({
            ...args,
            data: { ...args.data, organizationId },
          }),
        count: (args: any = {}) =>
          this.prisma.donation.count({
            ...args,
            where: { ...args.where, organizationId },
          }),
      },

      // Events
      events: {
        findMany: (args: any = {}) =>
          this.prisma.event.findMany({
            ...args,
            where: { ...args.where, organizationId },
          }),
        findFirst: (args: any = {}) =>
          this.prisma.event.findFirst({
            ...args,
            where: { ...args.where, organizationId },
          }),
        create: (args: any) =>
          this.prisma.event.create({
            ...args,
            data: { ...args.data, organizationId },
          }),
        update: (args: any) =>
          this.prisma.event.update({
            ...args,
            where: { ...args.where, organizationId },
          }),
        count: (args: any = {}) =>
          this.prisma.event.count({
            ...args,
            where: { ...args.where, organizationId },
          }),
      },

      // Attendance
      attendance: {
        findMany: (args: any = {}) =>
          this.prisma.attendanceRecord.findMany({
            ...args,
            where: { ...args.where, organizationId },
          }),
        create: (args: any) =>
          this.prisma.attendanceRecord.create({
            ...args,
            data: { ...args.data, organizationId },
          }),
        count: (args: any = {}) =>
          this.prisma.attendanceRecord.count({
            ...args,
            where: { ...args.where, organizationId },
          }),
      },

      // Media
      media: {
        findMany: (args: any = {}) =>
          this.prisma.media.findMany({
            ...args,
            where: { ...args.where, organizationId },
          }),
        create: (args: any) =>
          this.prisma.media.create({
            ...args,
            data: { ...args.data, organizationId },
          }),
        delete: (args: any) =>
          this.prisma.media.delete({
            where: { ...args.where, organizationId },
          }),
      },

      // Children
      children: {
        findMany: (args: any = {}) =>
          this.prisma.child.findMany({
            ...args,
            where: { ...args.where, organizationId },
          }),
        create: (args: any) =>
          this.prisma.child.create({
            ...args,
            data: { ...args.data, organizationId },
          }),
      },

      // Groups
      groups: {
        findMany: (args: any = {}) =>
          this.prisma.group.findMany({
            ...args,
            where: { ...args.where, organizationId },
          }),
        create: (args: any) =>
          this.prisma.group.create({
            ...args,
            data: { ...args.data, organizationId },
          }),
      },

      // Announcements
      announcements: {
        findMany: (args: any = {}) =>
          this.prisma.announcement.findMany({
            ...args,
            where: { ...args.where, organizationId },
          }),
        create: (args: any) =>
          this.prisma.announcement.create({
            ...args,
            data: { ...args.data, organizationId },
          }),
      },
    };
  }

  /**
   * Validate that a resource belongs to the specified organization
   */
  async validateResourceOwnership(
    model: string,
    resourceId: string,
    organizationId: string,
  ): Promise<boolean> {
    const resource = await (this.prisma as any)[model].findFirst({
      where: { id: resourceId, organizationId },
    });
    return !!resource;
  }
}
