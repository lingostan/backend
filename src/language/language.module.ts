import { Module } from '@nestjs/common';
import { LanguageController } from './language.controller';
import { LanguageService } from './language.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { LessonModule } from '/lesson-module/entities/lesson-module.entity';
import { Question } from '/question/entities/question.entity';
import { UserLanguage } from '/users/entities/user-language.entity';
import { UserModuleProgress } from '/users/entities/user-module-progress.entity';
import { Language } from './entities/language.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Language,
      LessonModule,
      Question,
      UserLanguage,
      UserModuleProgress,
    ]),
  ],
  controllers: [LanguageController],
  providers: [LanguageService],
  exports: [LanguageService],
})
export class LanguageModule {}
