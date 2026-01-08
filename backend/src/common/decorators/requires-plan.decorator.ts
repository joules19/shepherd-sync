import { SetMetadata } from '@nestjs/common';
import { PlanType } from '@prisma/client';

export const REQUIRED_PLAN_KEY = 'requiredPlan';

/**
 * Decorator to restrict endpoint access based on subscription plan
 * Usage: @RequiresPlan(PlanType.PRO, PlanType.PREMIUM)
 */
export const RequiresPlan = (...plans: PlanType[]) => SetMetadata(REQUIRED_PLAN_KEY, plans);
