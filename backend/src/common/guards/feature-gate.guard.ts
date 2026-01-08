import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { PrismaService } from '@/core/database/prisma.service';
import { PlanType } from '@prisma/client';
import { REQUIRED_PLAN_KEY } from '../decorators/requires-plan.decorator';
import { IS_PUBLIC_KEY } from '../decorators/public.decorator';

/**
 * FeatureGateGuard implements subscription-based feature access control
 * Usage: @RequiresPlan(PlanType.PRO, PlanType.PREMIUM)
 */
@Injectable()
export class FeatureGateGuard implements CanActivate {
  // Plan hierarchy for comparison
  private readonly planHierarchy = {
    [PlanType.TRIAL]: 0,
    [PlanType.BASIC]: 1,
    [PlanType.PRO]: 2,
    [PlanType.PREMIUM]: 3,
  };

  constructor(
    private reflector: Reflector,
    private prisma: PrismaService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    // Skip for public routes
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (isPublic) {
      return true;
    }

    const requiredPlans = this.reflector.getAllAndOverride<PlanType[]>(REQUIRED_PLAN_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (!requiredPlans || requiredPlans.length === 0) {
      // No plan requirement specified, allow access
      return true;
    }

    const request = context.switchToHttp().getRequest();
    const user = request.user;
    const organizationId = request.organizationId || user?.organizationId;

    if (!organizationId) {
      throw new ForbiddenException('Organization not found');
    }

    // Fetch organization with plan details
    const organization = await this.prisma.organization.findUnique({
      where: { id: organizationId },
      select: {
        planType: true,
        isActive: true,
        subscriptionStatus: true,
        trialEndsAt: true,
      },
    });

    if (!organization) {
      throw new ForbiddenException('Organization not found');
    }

    // Check if organization subscription is active
    if (!organization.isActive) {
      throw new ForbiddenException('Organization subscription is inactive');
    }

    // Check if trial has expired
    if (organization.planType === PlanType.TRIAL && organization.trialEndsAt) {
      if (new Date() > organization.trialEndsAt) {
        throw new ForbiddenException('Trial period has expired. Please upgrade your plan.');
      }
    }

    // Check if organization's plan meets the requirement
    const currentPlanLevel = this.planHierarchy[organization.planType];
    const hasAccess = requiredPlans.some(
      (plan) => currentPlanLevel >= this.planHierarchy[plan],
    );

    if (!hasAccess) {
      const lowestRequiredPlan = requiredPlans
        .map((plan) => this.planHierarchy[plan])
        .sort((a, b) => a - b)[0];

      const planName = Object.keys(this.planHierarchy).find(
        (key) => this.planHierarchy[key as PlanType] === lowestRequiredPlan,
      );

      throw new ForbiddenException(
        `This feature requires ${planName} plan or higher. Current plan: ${organization.planType}`,
      );
    }

    return true;
  }
}
