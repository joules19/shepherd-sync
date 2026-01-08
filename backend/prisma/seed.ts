import { PrismaClient, UserRole, PlanType, SubscriptionStatus } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting database seed...');

  // Create demo organization
  const demoOrg = await prisma.organization.upsert({
    where: { subdomain: 'demo' },
    update: {},
    create: {
      name: 'Demo Church',
      subdomain: 'demo',
      planType: PlanType.PRO,
      subscriptionStatus: SubscriptionStatus.ACTIVE,
      timezone: 'America/New_York',
      currency: 'USD',
      isActive: true,
    },
  });

  console.log('✅ Created demo organization:', demoOrg.name);

  // Create super admin user
  const hashedPassword = await bcrypt.hash('password123', 10);

  const superAdmin = await prisma.user.upsert({
    where: { email: 'admin@shepherdsync.com' },
    update: {},
    create: {
      organizationId: demoOrg.id,
      email: 'admin@shepherdsync.com',
      passwordHash: hashedPassword,
      firstName: 'Super',
      lastName: 'Admin',
      role: UserRole.SUPER_ADMIN,
      emailVerified: true,
      isActive: true,
    },
  });

  console.log('✅ Created super admin:', superAdmin.email);

  // Create demo church admin
  const churchAdmin = await prisma.user.upsert({
    where: { email: 'pastor@demo.shepherdsync.com' },
    update: {},
    create: {
      organizationId: demoOrg.id,
      email: 'pastor@demo.shepherdsync.com',
      passwordHash: hashedPassword,
      firstName: 'John',
      lastName: 'Doe',
      role: UserRole.ADMIN,
      emailVerified: true,
      isActive: true,
    },
  });

  console.log('✅ Created church admin:', churchAdmin.email);

  console.log('🎉 Database seeded successfully!');
  console.log('');
  console.log('Login credentials:');
  console.log('- Super Admin: admin@shepherdsync.com / password123');
  console.log('- Church Admin: pastor@demo.shepherdsync.com / password123');
}

main()
  .catch((e) => {
    console.error('❌ Seed error:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
