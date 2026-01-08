import { Request } from 'express';
import { UserRole } from '@prisma/client';

/**
 * Extended Request interface with authenticated user and organization context
 */
export interface RequestWithUser extends Request {
  user: {
    id: string;
    email: string;
    firstName: string;
    lastName: string;
    role: UserRole;
    organizationId: string;
  };
  organizationId?: string;
}
