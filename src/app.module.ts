import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TypeOrmConfig } from './database/typeorm.config';
import { UsersModule } from './users/users.module';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './auth/auth.module';
import { Language } from './language/entities/language.entity';
import { LessonModule } from './lesson-module/entities/lesson-module.entity';
import { Question } from './question/entities/question.entity';
import { UserLanguage } from './users/entities/user-language.entity';
import { UserModuleProgress } from './users/entities/user-module-progress.entity';
import { LanguageModule } from './language/language.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRoot({
      ...TypeOrmConfig,
      entities: [
        Language,
        LessonModule,
        Question,
        UserLanguage,
        UserModuleProgress,
      ],
    }),
    UsersModule,
    AuthModule,
    LanguageModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
