import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { UsersModule } from '../../users/users.module';
import { Exercise } from './entities/exercise.entity';
import { UserExerciseProgress } from '../progress/entities/user-exercise-progress.entity';
import { ProgressModule } from '../progress/progress.module';
import { ExercisesController } from './exercises.controller';
import { ExercisesService } from './exercises.service';
import { LanguageModule } from '/language/language.module';
import { Language } from '/language/entities/language.entity';
import { Lesson } from '../lessons/entities/lesson.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Exercise,
      UserExerciseProgress,
      Language,
      Lesson,
    ]),
    ProgressModule,
    UsersModule,
  ],
  controllers: [ExercisesController],
  providers: [ExercisesService],
  exports: [ExercisesService],
})
export class ExercisesModule {}
