import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import MigrationOrmSource from './database/typeorm.config';
import cookieParser from 'cookie-parser';

async function bootstrap() {
  try {
    await MigrationOrmSource.initialize();
    console.log('✅ DB connected');
    await MigrationOrmSource.runMigrations();
    console.log('✅ Migrations applied');
  } catch (err) {
    console.error('❌ DB init error:', err.message);
  }

  const app = await NestFactory.create(AppModule);

  app.use(cookieParser());

  app.enableCors({
    origin: true,
    credentials: true,
  });

  const config = new DocumentBuilder()
    .setTitle('API')
    .setDescription('My NestJS API')
    .setVersion('1.0')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  app.useGlobalPipes(new ValidationPipe());
  app.enableCors();

  const port = process.env.PORT || 3000;

  await app.listen(port);
}
bootstrap();
