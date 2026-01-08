import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { IS_PUBLIC_KEY } from '../decorators/public.decorator';

/**
 * TenantGuard ensures multi-tenant data isolation
 * CRITICAL: This guard must be used on ALL tenant-scoped routes
 */
@Injectable()
export class TenantGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    // Skip for public routes
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (isPublic) {
      return true;
    }

    const request = context.switchToHttp().getRequest();
    const user = request.user;

    if (!user) {
      throw new ForbiddenException('User not authenticated');
    }

    // Super admins can access all organizations
    if (user.role === 'SUPER_ADMIN') {
      // For super admins, organizationId can come from query params
      const orgIdFromQuery = request.query.organizationId || request.params.organizationId;
      request.organizationId = orgIdFromQuery || user.organizationId;
      return true;
    }

    // For regular users, validate tenant isolation
    const organizationId = user.organizationId;

    if (!organizationId) {
      throw new ForbiddenException('User has no organization assigned');
    }

    // Check subdomain-based tenant isolation (optional enhancement)
    const host = request.headers.host;
    if (host && process.env.NODE_ENV === 'production') {
      const subdomain = this.extractSubdomain(host);
      // In production, you could validate subdomain matches user's organization
      // This is an additional layer of security
    }

    // Inject organizationId into request for downstream use
    request.organizationId = organizationId;

    // Validate resource access (if resourceId in params)
    const resourceOrgId = request.params.organizationId || request.body.organizationId;
    if (resourceOrgId && resourceOrgId !== organizationId) {
      throw new ForbiddenException('Access denied to this organization');
    }

    return true;
  }

  private extractSubdomain(host: string): string | null {
    // Example: firstchurch.shepherdsync.com -> firstchurch
    const parts = host.split('.');
    if (parts.length >= 3) {
      return parts[0];
    }
    return null;
  }
}
