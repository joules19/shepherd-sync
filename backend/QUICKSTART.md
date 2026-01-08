# ⚡ Quick Start Guide

Get Shepherd Sync running in 5 minutes!

## Prerequisites

- Node.js 18+ installed
- Docker & Docker Compose installed (or PostgreSQL + Redis locally)

## Option 1: Docker Setup (Recommended)

### Step 1: Start Database Services

```bash
docker-compose up -d
```

This starts:
- PostgreSQL on port 5432
- Redis on port 6379

### Step 2: Install Dependencies

```bash
npm install
```

### Step 3: Setup Environment

```bash
cp .env.example .env
```

The default `.env.example` is already configured for Docker setup!

### Step 4: Setup Database

```bash
# Generate Prisma Client
npm run prisma:generate

# Run migrations
npm run prisma:migrate:dev

# Seed demo data
npm run prisma:seed
```

### Step 5: Start the Server

```bash
npm run start:dev
```

### Step 6: Test It!

Visit:
- **API Docs:** http://localhost:3000/api/v1/docs
- **Health Check:** http://localhost:3000/api/v1/health (if you add a health endpoint)

**Login with demo account:**
```json
{
  "email": "admin@shepherdsync.com",
  "password": "password123"
}
```

---

## Option 2: Local Setup (Without Docker)

### Step 1: Install PostgreSQL & Redis

**macOS (using Homebrew):**
```bash
brew install postgresql@15 redis
brew services start postgresql@15
brew services start redis
```

**Ubuntu/Debian:**
```bash
sudo apt-get install postgresql-15 redis-server
sudo systemctl start postgresql
sudo systemctl start redis-server
```

**Windows:**
- Download PostgreSQL: https://www.postgresql.org/download/windows/
- Download Redis: https://github.com/tporadowski/redis/releases

### Step 2: Create Database

```bash
psql -U postgres
CREATE DATABASE shepherdsync;
\q
```

### Step 3: Setup Environment

```bash
cp .env.example .env
```

Update `DATABASE_URL` in `.env` if needed:
```env
DATABASE_URL="postgresql://postgres:your-password@localhost:5432/shepherdsync?schema=public"
```

### Step 4: Install & Setup

```bash
# Install dependencies
npm install

# Generate Prisma Client
npm run prisma:generate

# Run migrations
npm run prisma:migrate:dev

# Seed demo data
npm run prisma:seed
```

### Step 5: Start the Server

```bash
npm run start:dev
```

---

## 🎉 You're Done!

Visit http://localhost:3000/api/v1/docs to explore the API.

### Demo Credentials

- **Super Admin:** admin@shepherdsync.com / password123
- **Church Admin:** pastor@demo.shepherdsync.com / password123

### Next Steps

1. Try the `/auth/login` endpoint
2. Copy the `accessToken` from the response
3. Click "Authorize" in Swagger UI and paste the token
4. Explore the protected endpoints!

### Useful Commands

```bash
# View logs
npm run start:dev

# Stop Docker services
docker-compose down

# Reset database
npm run prisma:migrate:reset

# Open Prisma Studio
npm run prisma:studio
```

---

## 🐛 Troubleshooting

**"Port 5432 already in use":**
- You have PostgreSQL already running locally
- Either use the local instance or stop it: `brew services stop postgresql`

**"Cannot connect to database":**
- Check DATABASE_URL in .env matches your setup
- Verify PostgreSQL is running: `psql -U postgres`

**"Prisma Client not found":**
- Run: `npm run prisma:generate`

**Redis connection failed:**
- Check Redis is running: `redis-cli ping` (should return PONG)
- Start Redis: `docker-compose up -d redis`

---

Need help? Check the [full README](./README.md) or [claude.md](./claude.md)
