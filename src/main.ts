import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import cookieParser from 'cookie-parser';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.use(cookieParser());

  app.setGlobalPrefix('api');

  // app.enableCors({
  //   origin: ['http://localhost:5173', 'http://localhost:8081'],
  //   credentials: true,
  // });

  const config = new DocumentBuilder()
    .setTitle('API')
    .setDescription('My NestJS API')
    .setVersion('1.0')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  app.useGlobalPipes(new ValidationPipe());

  const port = process.env.PORT || 3000;

  await app.listen(port);

  return app.getUrl();
}

(async (): Promise<void> => {
  try {
    const url = await bootstrap();
    console.log('Bootstrap', url);
  } catch (error) {
    console.error('Bootstrap', error);
  }
})();
