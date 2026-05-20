import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TypeOrmConfig } from './database/typeorm.config';
import { UsersModule } from './users/users.module';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './auth/auth.module';
import { LanguageModule } from './language/language.module';
import { FilesModule } from './files/files.module';
import { LearningModule } from './learning/learning.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRoot({
      ...TypeOrmConfig,
    }),
    UsersModule,
    AuthModule,
    LanguageModule,
    FilesModule,
    LearningModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
