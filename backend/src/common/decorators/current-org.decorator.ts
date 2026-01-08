import { createParamDecorator, ExecutionContext } from '@nestjs/common';

/**
 * Decorator to get the current organization ID from request
 * Usage: @CurrentOrg() organizationId: string
 */
export const CurrentOrg = createParamDecorator((data: unknown, ctx: ExecutionContext) => {
  const request = ctx.switchToHttp().getRequest();
  return request.organizationId || request.user?.organizationId;
});
