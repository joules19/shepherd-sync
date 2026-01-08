import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable } from 'rxjs';

/**
 * TenantInterceptor automatically injects organizationId into the request
 * This ensures all downstream services have access to the tenant context
 */
@Injectable()
export class TenantInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const user = request.user;

    if (user && user.organizationId) {
      // Inject organizationId into request for easy access
      request.organizationId = user.organizationId;
    }

    return next.handle();
  }
}
