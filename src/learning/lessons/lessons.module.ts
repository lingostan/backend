import { forwardRef, Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { LessonsService } from './lessons.service';
import { LessonsController } from './lessons.controller';
import { Lesson } from './entities/lesson.entity';
import { UserLessonProgress } from '../progress/entities/user-lesson-progress.entity';
import { UsersModule } from '../../users/users.module';
import { Mods } from '../mods/entities/mods.entity';
import { Exercise } from '../exercises/entities/exercise.entity';
import { ExercisesModule } from '../exercises/exercises.module';
import { User } from '/users/entities/user.entity';
import { UserModuleProgress } from '../progress/entities/user-module-progress.entity';
import { ModsModule } from '../mods/mods.module';
import { Language } from '/language/entities/language.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Lesson,
      UserLessonProgress,
      UserModuleProgress,
      Mods,
      Exercise,
      User,
      Language,
    ]),
    ExercisesModule,
    UsersModule,
    forwardRef(() => ModsModule),
  ],
  controllers: [LessonsController],
  providers: [LessonsService],
  exports: [LessonsService],
})
export class LessonsModule {}
