# Shepherd Sync - Claude Development Guide

**Version:** 1.0
**Last Updated:** January 2026
**Purpose:** This document provides context to Claude and other AI assistants about the Shepherd Sync project architecture, conventions, and best practices.

---

## 🎯 Project Overview

**Shepherd Sync** is a multi-tenant SaaS Church Management System built with:
- **Backend:** NestJS (TypeScript)
- **Database:** PostgreSQL with Prisma ORM
- **Architecture:** Multi-tenant (single database, row-level isolation)
- **Email:** Postmark
- **Media Storage:** Cloudinary
- **Payments:** Stripe

**Key Features:**
- Member & visitor management
- Donation tracking (one-time & recurring)
- Event management & registration
- Attendance tracking (QR code & manual)
- Media gallery
- Communications (push, email, SMS)
- Children & teens management
- Analytics & reporting
- Subscription management (Basic, Pro, Premium plans)

---

## 🏗️ Architecture Principles

### 1. Multi-Tenancy Rules (CRITICAL)

**Every tenant-scoped table MUST include `organizationId`.**

**ALWAYS apply tenant isolation:**
```typescript
// ✅ CORRECT - All controllers must have tenant guards
@Controller('members')
@UseGuards(JwtAuthGuard, TenantGuard)
export class MembersController {}

// ❌ WRONG - Missing tenant guard (security vulnerability)
@Controller('members')
@UseGuards(JwtAuthGuard)
export class MembersController {}
```

**ALWAYS filter queries by organizationId:**
```typescript
// ✅ CORRECT
const members = await this.prisma.member.findMany({
  where: { organizationId },
});

// ❌ WRONG - Can leak data across tenants
const members = await this.prisma.member.findMany();
```

### 2. Module Structure

**Follow this structure for ALL business modules:**
```
src/modules/{module-name}/
├── {module-name}.module.ts
├── {module-name}.controller.ts
├── {module-name}.service.ts
├── dto/
│   ├── create-{entity}.dto.ts
│   ├── update-{entity}.dto.ts
│   └── query-{entity}.dto.ts
└── entities/
    └── {entity}.entity.ts (if needed)
```

**Example:**
```
src/modules/donations/
├── donations.module.ts
├── donations.controller.ts
├── donations.service.ts
├── stripe.service.ts
├── webhooks.controller.ts
├── dto/
│   ├── create-donation.dto.ts
│   ├── update-donation.dto.ts
│   └── query-donations.dto.ts
└── entities/
```

### 3. Role-Based Access Control (RBAC)

**User Roles Hierarchy:**
```typescript
enum UserRole {
  SUPER_ADMIN,  // Platform owner
  ADMIN,        // Church admin
  PASTOR,       // Church leadership
  USHER,        // Check-in staff
  MEMBER,       // Regular member
  PARENT,       // Parent with children
}
```

**ALWAYS use @Roles decorator for protected routes:**
```typescript
@Get('reports')
@Roles(UserRole.ADMIN, UserRole.PASTOR)
async getReports() {}
```

### 4. Feature Gating by Subscription Plan

**Plan Hierarchy:**
```typescript
TRIAL (0) < BASIC (1) < PRO (2) < PREMIUM (3)
```

**Use @RequiresPlan decorator:**
```typescript
@Get('advanced-analytics')
@RequiresPlan(PlanType.PRO, PlanType.PREMIUM)
async getAdvancedAnalytics() {}
```

**Feature Matrix:**
- **BASIC:** Core attendance, giving, events
- **PRO:** Analytics, children's module, media uploads
- **PREMIUM:** Multi-branch analytics, custom branding, priority support

---

## 🗄️ Database Conventions

### Prisma Schema Rules

1. **Every tenant-scoped model MUST have:**
   ```prisma
   model Example {
     id             String   @id @default(uuid())
     organizationId String

     organization   Organization @relation(fields: [organizationId], references: [id], onDelete: Cascade)

     createdAt      DateTime @default(now())
     updatedAt      DateTime @updatedAt

     @@index([organizationId])
   }
   ```

2. **Use soft deletes for important data:**
   ```prisma
   deletedAt DateTime?
   ```

3. **ALWAYS add indexes for:**
   - `organizationId`
   - Foreign keys
   - Fields used in WHERE clauses
   - Fields used in ORDER BY

4. **Use enums for fixed categories:**
   ```prisma
   enum DonationType {
     TITHE
     OFFERING
     BUILDING_FUND
     MISSIONS
     PASTOR_APPRECIATION
     OTHER
   }
   ```

### Migration Strategy

```bash
# Create migration
npm run prisma:migrate:dev --name descriptive-name

# Apply migrations in production
npm run prisma:migrate:deploy
```

---

## 🔐 Security Best Practices

### 1. Authentication Flow

```typescript
// All protected routes MUST use these guards (in order):
@UseGuards(JwtAuthGuard, TenantGuard, RolesGuard)

// Public routes use @Public() decorator
@Public()
@Post('login')
async login() {}
```

### 2. Payment Security

```typescript
// ALWAYS use idempotency keys for Stripe
const payment = await stripe.paymentIntents.create({
  amount,
  currency: 'usd',
}, {
  idempotencyKey: `donation-${userId}-${Date.now()}`,
});

// ALWAYS verify webhook signatures
const event = stripe.webhooks.constructEvent(
  rawBody,
  signature,
  webhookSecret,
);
```

### 3. File Upload Security

```typescript
// ALWAYS validate file types and sizes
@UseInterceptors(FileInterceptor('file', {
  limits: { fileSize: 10 * 1024 * 1024 }, // 10MB
  fileFilter: (req, file, cb) => {
    if (!file.mimetype.match(/image|video/)) {
      return cb(new BadRequestException('Invalid file type'), false);
    }
    cb(null, true);
  },
}))
```

### 4. Data Validation

```typescript
// ALWAYS use DTOs with class-validator
export class CreateMemberDto {
  @IsString()
  @IsNotEmpty()
  firstName: string;

  @IsEmail()
  @IsOptional()
  email?: string;

  @IsEnum(Gender)
  @IsOptional()
  gender?: Gender;
}
```

---

## 📧 Email Service (Postmark)

### Email Templates

**Template IDs:**
- Welcome email: `welcome-email`
- Donation receipt: `donation-receipt`
- Event registration: `event-registration`
- Password reset: `password-reset`
- Event reminder: `event-reminder`

**Usage:**
```typescript
await this.emailService.sendTransactional(
  user.email,
  'donation-receipt',
  {
    donorName: user.firstName,
    amount: donation.amount,
    date: donation.createdAt,
    receiptUrl: donation.receiptUrl,
  }
);
```

---

## 🖼️ Media Management (Cloudinary)

### Folder Structure

```
uploads/
  ├── {organizationId}/
      ├── profile-pictures/
      ├── event-media/
      ├── children-media/     # Restricted to parents
      └── sermons/
```

### Upload Patterns

```typescript
// ALWAYS organize by tenant
const result = await this.cloudinaryService.uploadImage(
  file,
  'event-media',
  organizationId,  // ← Tenant isolation
);

// Generate optimized URLs
const thumbnailUrl = this.cloudinaryService.getProfilePicUrl(
  publicId,
  200, // size
);
```

---

## 🎫 Event Management

### QR Code Generation

```typescript
// Each event gets a unique QR code
const qrCode = await this.generateQRCode({
  eventId: event.id,
  organizationId: event.organizationId,
});

// QR code contains: {eventId}/{organizationId}
```

### Check-In Flow

1. Scan QR code → Extract eventId + organizationId
2. Validate tenant isolation
3. Create attendance record
4. Send confirmation notification

---

## 📊 Analytics & Reporting

### Report Types

1. **Giving Reports:**
   - Total donations by period
   - Donations by type
   - Recurring vs one-time
   - Top donors (anonymized)

2. **Attendance Reports:**
   - Attendance trends
   - By service type
   - By age group
   - Member vs visitor

3. **Engagement Reports:**
   - Event registrations
   - Media views
   - Announcement reach

### Export Format

```typescript
// ALWAYS support CSV and Excel exports
@Get('reports/giving/export')
@Header('Content-Type', 'text/csv')
@Header('Content-Disposition', 'attachment; filename="giving-report.csv"')
async exportGivingReport() {}
```

---

## 🔄 Offline Sync (Usher App)

### Sync Strategy

```typescript
// Local storage schema
interface OfflineAttendanceRecord {
  tempId: string;           // Local UUID
  userId: string;
  serviceDate: string;
  checkInTime: string;
  wasOffline: true;
  syncStatus: 'pending' | 'synced' | 'conflict';
}

// Sync endpoint
@Post('attendance/sync')
async syncOfflineRecords(@Body() records: OfflineAttendanceRecord[]) {
  // Last-write-wins for conflicts
  // Deduplicate by userId + serviceDate
}
```

---

## 🧪 Testing Standards

### Unit Tests

```typescript
// Test services in isolation
describe('DonationsService', () => {
  it('should create donation with organizationId', async () => {
    const result = await service.create(organizationId, createDto);
    expect(result.organizationId).toBe(organizationId);
  });

  it('should prevent cross-tenant access', async () => {
    await expect(
      service.findOne(wrongOrgId, donationId)
    ).rejects.toThrow(ForbiddenException);
  });
});
```

### Integration Tests

```typescript
// Test API endpoints with tenant isolation
describe('DonationsController (e2e)', () => {
  it('should enforce tenant isolation', async () => {
    const churchA = await createChurch();
    const churchB = await createChurch();
    const userB = await createUser(churchB.id);

    const response = await request(app)
      .get('/donations')
      .set('Authorization', `Bearer ${userB.token}`)
      .set('Host', `${churchA.subdomain}.shepherdsync.com`);

    expect(response.status).toBe(403);
  });
});
```

---

## 🚀 Deployment

### Environment Variables

```bash
# Required for all environments
NODE_ENV=production
PORT=3000
API_PREFIX=api/v1

DATABASE_URL=postgresql://...
REDIS_URL=redis://...

JWT_SECRET=...
JWT_EXPIRATION=7d

POSTMARK_API_KEY=...
CLOUDINARY_CLOUD_NAME=...
CLOUDINARY_API_KEY=...
CLOUDINARY_API_SECRET=...

STRIPE_SECRET_KEY=...
STRIPE_WEBHOOK_SECRET=...

FRONTEND_URL=https://app.shepherdsync.com
```

### Migration Checklist

```bash
# Before deployment
1. Run tests: npm run test
2. Build: npm run build
3. Run migrations: npm run prisma:migrate:deploy
4. Generate Prisma client: npm run prisma:generate
5. Deploy
6. Health check: GET /health
```

---

## 📝 Code Style & Conventions

### Naming Conventions

- **Files:** kebab-case (`donations.service.ts`)
- **Classes:** PascalCase (`DonationsService`)
- **Functions/Methods:** camelCase (`createDonation()`)
- **Constants:** UPPER_SNAKE_CASE (`MAX_FILE_SIZE`)
- **Interfaces:** PascalCase with `I` prefix optional (`CreateDonationDto`)

### Import Order

```typescript
// 1. Node modules
import { Injectable } from '@nestjs/common';

// 2. Core modules
import { PrismaService } from '@/core/database/prisma.service';

// 3. Common utilities
import { TenantGuard } from '@/common/guards/tenant.guard';

// 4. Local imports
import { CreateDonationDto } from './dto/create-donation.dto';
```

### Error Handling

```typescript
// Use NestJS built-in exceptions
throw new NotFoundException('Member not found');
throw new ForbiddenException('Access denied to this organization');
throw new BadRequestException('Invalid donation amount');
throw new UnauthorizedException('Invalid credentials');

// For custom errors
throw new HttpException(
  'Custom error message',
  HttpStatus.UNPROCESSABLE_ENTITY,
);
```

---

## 🐛 Common Pitfalls to Avoid

### ❌ DON'T: Forget tenant isolation
```typescript
// BAD - Missing organizationId filter
const members = await this.prisma.member.findMany();
```

### ✅ DO: Always filter by tenant
```typescript
// GOOD
const members = await this.prisma.member.findMany({
  where: { organizationId },
});
```

### ❌ DON'T: Expose sensitive data
```typescript
// BAD - Returns password hash
return user;
```

### ✅ DO: Use select or exclude sensitive fields
```typescript
// GOOD
return this.prisma.user.findUnique({
  where: { id },
  select: {
    id: true,
    email: true,
    firstName: true,
    lastName: true,
    role: true,
    // passwordHash excluded
  },
});
```

### ❌ DON'T: Use magic numbers/strings
```typescript
// BAD
if (user.role === 'admin') {}
```

### ✅ DO: Use enums and constants
```typescript
// GOOD
if (user.role === UserRole.ADMIN) {}
```

---

## 📊 Work Tracking Workflow

### Daily Development Workflow

Shepherd Sync uses a **simple two-file tracking system** for solo development:

1. **TODO.md** - Master task list (what needs to be done)
2. **JOURNAL.md** - Daily development log (what was done)

### Morning Routine (5 minutes)

```markdown
1. Open TODO.md
2. Review current sprint section
3. Pick 2-3 tasks for today
4. Mark them as "In Progress" in your mind
```

### During Development

- Code normally following patterns in this document
- Commit frequently with semantic commit messages
- Reference TODO items in commits when relevant

**Semantic Commit Format:**
```bash
feat(members): add CSV import functionality
fix(auth): resolve token expiration issue
docs: update API examples in README
test(giving): add donation webhook tests
refactor(database): optimize tenant queries
```

### End of Day (5 minutes)

```markdown
1. Update JOURNAL.md:
   - Log hours worked
   - List completed tasks
   - Note next steps
   - Document any blockers
   - Add insights/learnings

2. Update TODO.md:
   - Check off completed tasks [x]
   - Move tasks between phases if needed
   - Add any new tasks discovered
```

### Weekly Review (15 minutes)

Every Friday or end of sprint:

1. Review JOURNAL.md weekly summary
2. Calculate total hours and tasks completed
3. Update milestones in TODO.md
4. Plan next week's focus areas
5. Document lessons learned

### Progress Tracking Commands

```bash
# See what you've done this week
git log --since="1 week ago" --oneline

# Count completed tasks
cat TODO.md | grep "\[x\]" | wc -l

# View recent work
tail -50 JOURNAL.md
```

### Task States in TODO.md

- `[ ]` - Not started
- `[x]` - Completed
- Use **Bold** for currently in progress
- Use ~~Strikethrough~~ for cancelled/obsolete

### When to Update Tracking

**Always update:**
- When completing a module or major feature
- When hitting a blocker
- At end of each work session
- When discovering new tasks

**Don't over-track:**
- Small refactors (< 30 min)
- Documentation typos
- Routine code reviews

### Integration with Development

```typescript
// Link commits to TODO tasks
git commit -m "feat(organizations): add CRUD endpoints

- Completed Organizations module CRUD
- Added validation and error handling
- Wrote unit tests

Related: TODO.md Phase 1 - Organizations Module"
```

### Example Daily Flow

```
9:00 AM  - Review TODO.md, pick tasks
9:05 AM  - Start coding Organizations module
12:00 PM - Commit: "feat(organizations): add create endpoint"
12:30 PM - Lunch
1:30 PM  - Continue coding
4:00 PM  - Commit: "feat(organizations): add update/delete endpoints"
5:00 PM  - Update JOURNAL.md with progress
5:05 PM  - Check off completed tasks in TODO.md
```

### Benefits

✅ **5-10 minutes daily overhead**
✅ **Clear progress visibility**
✅ **Historical reference for decisions**
✅ **Easy to resume after breaks**
✅ **Generates natural documentation**
✅ **Scales to team collaboration later**

---

## 📚 Additional Resources

- **PRD:** `/Shepherd_Sync_README.md`
- **Database Schema:** `/prisma/schema.prisma`
- **API Docs:** `http://localhost:3000/api/docs` (Swagger)
- **Work Tracking:** `/TODO.md` and `/JOURNAL.md`

---

## 🎯 When Adding New Features

### Checklist for New Modules

- [ ] Create module structure following conventions
- [ ] Add Prisma models with `organizationId`
- [ ] Create migrations
- [ ] Implement tenant guards on all routes
- [ ] Add RBAC with @Roles decorator
- [ ] Add feature gating if needed (@RequiresPlan)
- [ ] Create DTOs with validation
- [ ] Write unit tests (80% coverage minimum)
- [ ] Write integration tests for critical paths
- [ ] Update API documentation (Swagger)
- [ ] Add audit logging for sensitive operations
- [ ] Update this claude.md if needed

### Checklist for Bug Fixes

- [ ] Reproduce the bug with a test
- [ ] Fix the issue
- [ ] Verify test now passes
- [ ] Check for similar issues in other modules
- [ ] Update related documentation

---

## 💬 Questions or Clarifications?

If anything is unclear or you need to make architectural decisions:
1. Check this document first
2. Check the PRD (`/Shepherd_Sync_README.md`)
3. Ask the user for clarification
4. Update this document with the decision

---

**Remember:** Consistency is key. When in doubt, follow the patterns established in existing modules.
