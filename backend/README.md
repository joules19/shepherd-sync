# Shepherd Sync - Church Management System API

Multi-tenant SaaS platform for church operations management built with NestJS, Prisma, and PostgreSQL.

## 📋 Table of Contents

- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Prerequisites](#-prerequisites)
- [Getting Started](#-getting-started)
- [Architecture](#-architecture)
- [Multi-Tenancy](#-multi-tenancy)
- [API Documentation](#-api-documentation)
- [Development](#-development)
- [Testing](#-testing)
- [Deployment](#-deployment)

---

## 🎯 Features

### Core Features
- ✅ Multi-tenant architecture with organization isolation
- ✅ JWT-based authentication with refresh tokens
- ✅ Role-based access control (RBAC)
- ✅ Subscription-based feature gating (TRIAL, BASIC, PRO, PREMIUM)
- ✅ Member & visitor management
- ✅ Donation tracking with Stripe integration
- ✅ Event management & registration
- ✅ Attendance tracking (QR code & manual)
- ✅ Media gallery with Cloudinary
- ✅ Communications (Email via Postmark, Push notifications)
- ✅ Children & teens management
- ✅ Groups & ministries
- ✅ Analytics & reporting
- ✅ Audit logging

---

## 🛠️ Tech Stack

### Backend
- **Framework:** NestJS 10.x (TypeScript)
- **Database:** PostgreSQL 15+
- **ORM:** Prisma 5.x
- **Authentication:** JWT (Passport.js)
- **Caching:** Redis
- **Queue:** Bull (Redis-based)

### External Services
- **Email:** Postmark
- **Media Storage:** Cloudinary
- **Payments:** Stripe
- **Push Notifications:** Firebase Cloud Messaging (FCM)

### Development Tools
- **Documentation:** Swagger/OpenAPI
- **Testing:** Jest
- **Linting:** ESLint + Prettier
- **CI/CD:** GitHub Actions (recommended)

---

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** 18+ ([Download](https://nodejs.org/))
- **PostgreSQL** 15+ ([Download](https://www.postgresql.org/download/))
- **Redis** 7+ ([Download](https://redis.io/download))
- **npm** or **yarn**

### Optional (for Docker setup)
- **Docker** ([Download](https://www.docker.com/))
- **Docker Compose** ([Download](https://docs.docker.com/compose/install/))

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/shepherd-sync.git
cd shepherd-sync
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Environment Setup

Copy the environment example file:

```bash
cp .env.example .env
```

Update `.env` with your configuration:

```env
# Database
DATABASE_URL="postgresql://postgres:password@localhost:5432/shepherdsync?schema=public"

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_REFRESH_SECRET=your-super-secret-refresh-key-change-in-production

# Postmark (Email)
POSTMARK_API_KEY=your-postmark-api-key
POSTMARK_FROM_EMAIL=noreply@shepherdsync.com

# Cloudinary (Media)
CLOUDINARY_CLOUD_NAME=your-cloud-name
CLOUDINARY_API_KEY=your-api-key
CLOUDINARY_API_SECRET=your-api-secret

# Stripe (Payments)
STRIPE_SECRET_KEY=sk_test_your-stripe-secret-key
STRIPE_WEBHOOK_SECRET=whsec_your-webhook-secret
```

### 4. Database Setup

```bash
# Generate Prisma Client
npm run prisma:generate

# Run migrations
npm run prisma:migrate:dev

# Seed database with demo data
npm run prisma:seed
```

### 5. Start Development Server

```bash
npm run start:dev
```

The API will be available at:
- **API:** http://localhost:3000
- **Swagger Docs:** http://localhost:3000/api/v1/docs

### 6. Test the API

**Login with demo credentials:**

```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@shepherdsync.com",
    "password": "password123"
  }'
```

Or use the Swagger UI at http://localhost:3000/api/v1/docs

---

## 🏗️ Architecture

### Project Structure

```
src/
├── common/                      # Shared utilities
│   ├── decorators/             # Custom decorators (@CurrentUser, @Roles, etc.)
│   ├── guards/                 # Security guards (JWT, Tenant, Roles, FeatureGate)
│   ├── interceptors/           # Interceptors (Logging, Transform, Tenant)
│   ├── filters/                # Exception filters (HTTP, Prisma)
│   ├── pipes/                  # Validation pipes
│   └── types/                  # Shared types/interfaces
│
├── core/                        # Core infrastructure modules
│   ├── database/               # Prisma service & tenant helpers
│   ├── auth/                   # Authentication (JWT, OAuth)
│   ├── email/                  # Email service (Postmark)
│   ├── upload/                 # File upload (Cloudinary)
│   ├── notification/           # Push notifications (FCM)
│   └── queue/                  # Background jobs (Bull)
│
├── modules/                     # Business logic modules
│   ├── organizations/          # Organization management
│   ├── users/                  # User management
│   ├── members/                # Church members
│   ├── children/               # Children & teens
│   ├── giving/                 # Donations & tithes
│   ├── attendance/             # Attendance tracking
│   ├── events/                 # Events & registrations
│   ├── media/                  # Media gallery
│   ├── communications/         # Announcements
│   ├── groups/                 # Groups & ministries
│   ├── analytics/              # Reports & analytics
│   ├── subscriptions/          # Subscription management
│   └── super-admin/            # Platform administration
│
├── config/                      # Configuration files
├── utils/                       # Utility functions
├── main.ts                      # Application entry point
└── app.module.ts                # Root module
```

### Database Schema

See [prisma/schema.prisma](./prisma/schema.prisma) for the complete database schema.

**Key Models:**
- `Organization` - Tenant/church entity
- `User` - System users with roles
- `Member` - Church members/visitors
- `Child` - Children linked to parents
- `Donation` - Financial contributions
- `Event` - Church events
- `AttendanceRecord` - Service attendance
- `Media` - Photos/videos
- `Announcement` - Communications
- `Group` - Small groups/ministries

---

## 🔒 Multi-Tenancy

Shepherd Sync uses **row-level multi-tenancy** with a single shared database.

### How It Works

1. Every tenant-scoped table has an `organizationId` column
2. **TenantGuard** automatically enforces data isolation
3. **TenantService** provides scoped database queries
4. Users can only access data from their organization

### Security Layers

```typescript
// ALWAYS use these guards on tenant-scoped routes
@Controller('members')
@UseGuards(JwtAuthGuard, TenantGuard, RolesGuard)
export class MembersController {

  @Get()
  @Roles(UserRole.ADMIN, UserRole.PASTOR)
  async findAll(@CurrentOrg() organizationId: string) {
    // organizationId automatically injected and validated
  }
}
```

### Subscription Plans

| Plan | Features |
|------|----------|
| **TRIAL** | 14-day free trial, all PRO features |
| **BASIC** | Core attendance, giving, events |
| **PRO** | + Analytics, children module, media uploads |
| **PREMIUM** | + Multi-branch, custom branding, priority support |

**Feature Gating:**

```typescript
@Get('advanced-reports')
@RequiresPlan(PlanType.PRO, PlanType.PREMIUM)
async getAdvancedReports() {
  // Only accessible to PRO and PREMIUM plans
}
```

---

## 📚 API Documentation

### Swagger UI

Visit http://localhost:3000/api/v1/docs for interactive API documentation.

### Authentication

All protected endpoints require a JWT token in the `Authorization` header:

```
Authorization: Bearer <your-jwt-token>
```

### Example Requests

**Register a new church:**

```bash
POST /api/v1/auth/register
Content-Type: application/json

{
  "firstName": "John",
  "lastName": "Doe",
  "email": "pastor@mychurch.com",
  "password": "SecurePassword123!",
  "organizationName": "My Church",
  "subdomain": "mychurch"
}
```

**Get members:**

```bash
GET /api/v1/members?page=1&limit=20
Authorization: Bearer <token>
```

---

## 💻 Development

### Available Scripts

```bash
# Development
npm run start          # Start server
npm run start:dev      # Start with watch mode
npm run start:debug    # Start in debug mode

# Building
npm run build          # Build for production

# Database
npm run prisma:generate        # Generate Prisma Client
npm run prisma:migrate:dev     # Create and apply migration
npm run prisma:migrate:deploy  # Apply migrations (production)
npm run prisma:studio          # Open Prisma Studio
npm run prisma:seed            # Seed database

# Testing
npm run test           # Run unit tests
npm run test:watch     # Run tests in watch mode
npm run test:cov       # Run tests with coverage
npm run test:e2e       # Run end-to-end tests

# Code Quality
npm run lint           # Lint code
npm run format         # Format code with Prettier
```

### Adding a New Module

Follow the pattern in `claude.md`:

1. Create module directory: `src/modules/your-module/`
2. Create files:
   - `your-module.module.ts`
   - `your-module.controller.ts`
   - `your-module.service.ts`
   - `dto/` folder with DTOs
3. Add Prisma model with `organizationId`
4. Use tenant guards and decorators
5. Add to `app.module.ts`

### Code Style

- Follow NestJS conventions
- Use TypeScript strict mode
- Use DTOs for validation
- Always use guards for security
- Document with JSDoc comments

---

## 🧪 Testing

### Unit Tests

```bash
npm run test
```

### E2E Tests

```bash
npm run test:e2e
```

### Test Coverage

```bash
npm run test:cov
```

**Target:** 80% minimum coverage for business logic

---

## 🚀 Deployment

### Environment Variables

Ensure all production environment variables are set:

```env
NODE_ENV=production
DATABASE_URL=<production-db-url>
JWT_SECRET=<strong-secret>
STRIPE_SECRET_KEY=sk_live_...
# ... etc
```

### Build for Production

```bash
npm run build
```

### Run Production Server

```bash
npm run start:prod
```

### Database Migrations

```bash
npm run prisma:migrate:deploy
```

### Recommended Platforms

- **Backend:** Railway, Render, AWS Elastic Beanstalk, Heroku
- **Database:** Supabase, Railway, AWS RDS, Render PostgreSQL
- **Redis:** Upstash, Redis Cloud, AWS ElastiCache

### Docker Deployment

```bash
docker-compose up -d
```

---

## 📖 Additional Documentation

- [Product Requirements Document](./Shepherd_Sync_README.md)
- [Claude Development Guide](./claude.md)
- [API Documentation](http://localhost:3000/api/v1/docs) (when running)

---

## 🔐 Security Best Practices

1. **Never commit `.env` file** - It's in `.gitignore`
2. **Use strong JWT secrets** - Generate with: `openssl rand -base64 32`
3. **Enable HTTPS** in production
4. **Validate all inputs** with DTOs
5. **Use prepared statements** (Prisma handles this)
6. **Implement rate limiting** (ThrottlerModule configured)
7. **Log security events** (AuditLog model)
8. **Rotate secrets** regularly

---

## 🐛 Troubleshooting

### Database Connection Issues

```bash
# Check PostgreSQL is running
psql -U postgres

# Check DATABASE_URL in .env
echo $DATABASE_URL
```

### Prisma Client Not Found

```bash
npm run prisma:generate
```

### Redis Connection Failed

```bash
# Check Redis is running
redis-cli ping
# Should return: PONG
```

### Port Already in Use

```bash
# Change PORT in .env
PORT=3001
```

---

## 📞 Support

For issues and questions:
- GitHub Issues: [Create an issue](https://github.com/your-org/shepherd-sync/issues)
- Documentation: [claude.md](./claude.md)

---

## 📄 License

This project is licensed under UNLICENSED - See the [package.json](./package.json) file for details.

---

**Built with ❤️ for churches worldwide**
