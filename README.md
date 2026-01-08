# 🏛️ Shepherd Sync - Complete Platform

**Version:** 1.0
**Last Updated:** January 2026

---

## 📌 Overview

**Shepherd Sync** is a premium, multi-tenant SaaS Church Management System designed to empower churches with modern digital tools for member engagement, giving, attendance, events, and media management.

This is a **monorepo** containing:
- 🔥 **Backend API** - NestJS (TypeScript) + PostgreSQL + Prisma
- 📱 **Mobile App** - Flutter (iOS & Android)
- 🌐 **Web Dashboard** - Next.js + React (coming soon)

---

## 🗂️ Project Structure

```
shepherd-sync/
├── backend/              # NestJS API Server
│   ├── src/              # Source code
│   ├── prisma/           # Database schema & migrations
│   ├── test/             # Tests
│   ├── README.md         # Backend-specific README
│   ├── QUICKSTART.md     # Quick setup guide
│   ├── TODO.md           # Backend task tracker
│   ├── JOURNAL.md        # Backend development log
│   └── claude.md         # Backend development guide
│
├── mobile/               # Flutter Mobile App
│   ├── lib/              # Flutter source code
│   ├── TODO.md           # Mobile task tracker
│   ├── JOURNAL.md        # Mobile development log
│   └── claude.md         # Mobile development guide
│
├── docs/                 # Shared documentation
│   ├── Shepherd_Sync_README.md           # Product overview
│   └── Shepherd_Sync_Flutter_Design.docx # Mobile design specs
│
├── .vscode/              # VSCode workspace settings
└── README.md             # This file
```

---

## 🚀 Quick Start

### Prerequisites

- **Node.js** 18+ (for backend)
- **Flutter** 3.16+ (for mobile)
- **PostgreSQL** 14+ (database)
- **Redis** 7+ (caching & queues)
- **Docker** (optional, for local dev)

### Backend Setup

```bash
cd backend

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env
# Edit .env with your credentials

# Start database (Docker)
docker-compose up -d

# Run migrations
npm run prisma:migrate:dev

# Start development server
npm run start:dev

# API will be available at http://localhost:3000
# Swagger docs at http://localhost:3000/api
```

**See [backend/README.md](./backend/README.md) for detailed backend documentation.**

### Mobile Setup

```bash
cd mobile

# Install Flutter dependencies
flutter pub get

# Run on iOS simulator
flutter run -d "iPhone 15 Pro"

# Run on Android emulator
flutter run -d emulator-5554
```

**See [mobile/claude.md](./mobile/claude.md) for detailed mobile development guide.**

---

## 🎯 Key Features

### Core Modules
- ✅ **Organizations** - Multi-tenant church management
- ✅ **Users & Authentication** - JWT-based auth with role-based access
- ✅ **Members** - Member database with import/export
- ✅ **Giving** - Stripe integration for donations (one-time & recurring)
- ✅ **Events** - Event management with QR codes & registration
- 🚧 **Attendance** - QR code check-in with offline support
- 📋 **Media Gallery** - Cloudinary-based media management
- 📋 **Communications** - Push notifications, email, SMS
- 📋 **Children & Teens** - Parent-linked child management
- 📋 **Analytics** - Reports and insights dashboard

### Advanced Features
- 🔐 **Multi-tenancy** - Isolated data per organization
- 💳 **Subscription Plans** - Trial, Basic, Pro, Premium tiers
- 📊 **Feature Gating** - Plan-based feature access
- 🌐 **Offline Support** - Especially for usher attendance
- 🎨 **Custom Branding** - Per-organization theming
- 📱 **Push Notifications** - Firebase Cloud Messaging
- 📧 **Transactional Emails** - Postmark integration
- 💰 **Payment Processing** - Stripe for donations & subscriptions

---

## 🛠️ Technology Stack

### Backend
- **Framework:** NestJS (Node.js + TypeScript)
- **Database:** PostgreSQL 14+
- **ORM:** Prisma
- **Authentication:** JWT + Passport
- **Payments:** Stripe
- **Email:** Postmark
- **Media:** Cloudinary
- **Cache/Queue:** Redis + Bull
- **Validation:** class-validator
- **Documentation:** Swagger/OpenAPI

### Mobile
- **Framework:** Flutter 3.16+
- **Language:** Dart
- **State Management:** Riverpod 2.x
- **Networking:** Dio + Retrofit
- **Local Storage:** Hive + Drift (SQLite)
- **Navigation:** go_router
- **Secure Storage:** flutter_secure_storage
- **Payments:** Stripe SDK
- **QR Codes:** qr_flutter + mobile_scanner

### Infrastructure (Production)
- **API Hosting:** Render / AWS Elastic Beanstalk
- **Database:** AWS RDS (PostgreSQL)
- **CDN:** Cloudflare
- **Mobile:** App Store + Google Play
- **CI/CD:** GitHub Actions

---

## 📊 Development Status

### Backend API ✅ (Phase 1 & 2 Complete)
- ✅ Organizations Module
- ✅ Users Module (auth, invitations, password reset)
- ✅ Members Module (CRUD, import/export, statistics)
- ✅ Giving Module (Stripe integration, donations, receipts)
- ✅ Events Module (CRUD, registration, QR codes, payments)
- 🚧 Attendance Module (next)
- 📋 Media, Communications, Analytics (planned)

### Mobile App 📱 (Starting)
- ✅ Project structure planned
- 🚧 Flutter initialization (in progress)
- 📋 Auth screens (planned)
- 📋 Dashboard (planned)
- 📋 All feature modules (planned)

### Web Dashboard 🌐 (Future)
- 📋 Not started yet

---

## 👥 Team & Roles

### User Roles in the System
- **SUPER_ADMIN** - Platform owner (manages all churches)
- **ADMIN** - Church administrator (full access to their church)
- **PASTOR** - Church leadership (analytics, events, media)
- **USHER** - Check-in staff (attendance only)
- **MEMBER** - Regular member (donate, register for events)
- **PARENT** - Parent with children (manage child profiles)

---

## 📖 Documentation

- **Product Overview:** [docs/Shepherd_Sync_README.md](./docs/Shepherd_Sync_README.md)
- **Backend Guide:** [backend/README.md](./backend/README.md)
- **Backend Quick Start:** [backend/QUICKSTART.md](./backend/QUICKSTART.md)
- **Backend Development Guide:** [backend/claude.md](./backend/claude.md)
- **Mobile Development Guide:** [mobile/claude.md](./mobile/claude.md)
- **API Documentation:** http://localhost:3000/api (Swagger, when running)

---

## 🧪 Testing

### Backend
```bash
cd backend

# Unit tests
npm run test

# e2e tests
npm run test:e2e

# Test coverage
npm run test:cov
```

### Mobile
```bash
cd mobile

# Unit tests
flutter test

# Integration tests
flutter test integration_test/
```

---

## 🚀 Deployment

### Backend Deployment
```bash
cd backend

# Build production
npm run build

# Run migrations
npm run prisma:migrate:deploy

# Start production server
npm run start:prod
```

### Mobile Deployment

**iOS (App Store):**
```bash
cd mobile
flutter build ios --release
# Upload via Xcode or Transporter
```

**Android (Play Store):**
```bash
cd mobile
flutter build appbundle --release
# Upload via Play Console
```

---

## 🔐 Environment Variables

### Backend (.env)
```bash
# Database
DATABASE_URL=postgresql://user:pass@localhost:5432/shepherdsync

# JWT
JWT_SECRET=your-secret-key
JWT_EXPIRATION=7d

# Stripe
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Postmark
POSTMARK_API_KEY=your-api-key

# Cloudinary
CLOUDINARY_CLOUD_NAME=your-cloud-name
CLOUDINARY_API_KEY=your-api-key
CLOUDINARY_API_SECRET=your-api-secret
```

### Mobile (.env)
```bash
# API
API_BASE_URL=http://localhost:3000/api/v1

# Stripe
STRIPE_PUBLISHABLE_KEY=pk_test_...
```

---

## 📝 Development Workflow

### Working on Backend
1. Read [backend/claude.md](./backend/claude.md) for guidelines
2. Check [backend/TODO.md](./backend/TODO.md) for tasks
3. Make changes following NestJS best practices
4. Update [backend/JOURNAL.md](./backend/JOURNAL.md) daily
5. Write tests for all new features
6. Commit with semantic commit messages

### Working on Mobile
1. Read [mobile/claude.md](./mobile/claude.md) for guidelines
2. Check [mobile/TODO.md](./mobile/TODO.md) for tasks
3. Make changes following Flutter best practices
4. Update [mobile/JOURNAL.md](./mobile/JOURNAL.md) daily
5. Write tests for all new features
6. Commit with semantic commit messages

### Semantic Commits
```bash
feat(auth): add Google Sign-In
fix(giving): resolve Stripe webhook timeout
docs: update API documentation
test(members): add bulk import tests
refactor(events): optimize QR code generation
```

---

## 🤝 Contributing

This is currently a solo project, but contributions are welcome!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

**Proprietary** - All rights reserved.

This is a commercial SaaS product. Contact for licensing inquiries.

---

## 🙏 Acknowledgments

- **NestJS** - Amazing backend framework
- **Flutter** - Best cross-platform mobile framework
- **Prisma** - Best ORM for TypeScript
- **Stripe** - Reliable payment processing
- **Postmark** - Excellent email delivery
- **Cloudinary** - Powerful media management

---

## 📞 Support

For questions or issues:
- **Backend Issues:** Check [backend/README.md](./backend/README.md)
- **Mobile Issues:** Check [mobile/claude.md](./mobile/claude.md)
- **Product Questions:** See [docs/Shepherd_Sync_README.md](./docs/Shepherd_Sync_README.md)

---

## 🎯 Roadmap

### Q1 2026 (Jan-Mar)
- ✅ Backend Phase 1 & 2 complete
- 🚧 Mobile app development
- 📋 Attendance module
- 📋 Media module

### Q2 2026 (Apr-Jun)
- 📋 Communications module
- 📋 Analytics module
- 📋 Mobile beta launch
- 📋 First 10 churches onboarded

### Q3 2026 (Jul-Sep)
- 📋 Web dashboard
- 📋 Advanced analytics
- 📋 Multi-branch support
- 📋 Custom branding

### Q4 2026 (Oct-Dec)
- 📋 AI features (sermon transcription)
- 📋 WhatsApp integration
- 📋 Volunteer scheduling
- 📋 Scale to 100+ churches

---

**Built with ❤️ for churches around the world.**
