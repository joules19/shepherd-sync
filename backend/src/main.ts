import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { ConfigService } from '@nestjs/config';
import * as compression from 'compression';
import helmet from 'helmet';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    logger: ['error', 'warn', 'log', 'debug', 'verbose'],
  });

  const configService = app.get(ConfigService);

  // Security
  app.use(helmet());
  app.use(compression());

  // CORS
  app.enableCors({
    origin: [
      configService.get('FRONTEND_URL') || 'http://localhost:3001',
      configService.get('FRONTEND_ADMIN_URL') || 'http://localhost:3002',
      /\.shepherdsync\.com$/,
    ],
    credentials: true,
  });

  // Global prefix
  const apiPrefix = configService.get('API_PREFIX', 'api/v1');
  app.setGlobalPrefix(apiPrefix);

  // Global pipes
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  // Swagger API Documentation
  const config = new DocumentBuilder()
    .setTitle('Shepherd Sync API')
    .setDescription('Multi-tenant SaaS Church Management System API')
    .setVersion('1.0')
    .addBearerAuth(
      {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
        name: 'JWT',
        description: 'Enter JWT token',
        in: 'header',
      },
      'JWT-auth',
    )
    .addTag('auth', 'Authentication endpoints')
    .addTag('organizations', 'Organization management')
    .addTag('users', 'User management')
    .addTag('members', 'Member management')
    .addTag('children', 'Children & teens management')
    .addTag('giving', 'Donations and giving')
    .addTag('attendance', 'Attendance tracking')
    .addTag('events', 'Event management')
    .addTag('media', 'Media gallery')
    .addTag('communications', 'Announcements & communications')
    .addTag('groups', 'Groups & ministries')
    .addTag('analytics', 'Reports & analytics')
    .addTag('subscriptions', 'Subscription management')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup(`${apiPrefix}/docs`, app, document, {
    swaggerOptions: {
      persistAuthorization: true,
    },
  });

  const port = configService.get('PORT', 3000);
  await app.listen(port);

  console.log('');
  console.log('🚀 Shepherd Sync API is running!');
  console.log('');
  console.log(`📡 Server: http://localhost:${port}`);
  console.log(`📚 API Docs: http://localhost:${port}/${apiPrefix}/docs`);
  console.log(`🔧 Environment: ${configService.get('NODE_ENV')}`);
  console.log('');
}

bootstrap();
