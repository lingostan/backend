import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { LanguageController } from './language.controller';
import { LanguageService } from './language.service';
import { Language } from './entities/language.entity';
import { UsersModule } from '../users/users.module';
import { Mods } from '../learning/mods/entities/mods.entity';
import { Lesson } from '../learning/lessons/entities/lesson.entity';
import { Exercise } from '../learning/exercises/entities/exercise.entity';
import { UserExerciseProgress } from '../learning/progress/entities/user-exercise-progress.entity';
import { UserProgress } from '../learning/progress/entities/user-progress.entity';
import { UserLessonProgress } from '../learning/progress/entities/user-lesson-progress.entity';
import { UserModuleProgress } from '../learning/progress/entities/user-module-progress.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Language,
      Mods,
      Lesson,
      Exercise,
      UserExerciseProgress,
      UserLessonProgress,
      UserModuleProgress,
      UserProgress,
    ]),
    UsersModule,
  ],
  controllers: [LanguageController],
  providers: [LanguageService],
  exports: [LanguageService],
})
export class LanguageModule {}
