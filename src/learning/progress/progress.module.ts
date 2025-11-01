import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { UsersModule } from '../../users/users.module';
import { UserProgress } from './entities/user-progress.entity';
import { UserModuleProgress } from './entities/user-module-progress.entity';
import { UserLessonProgress } from './entities/user-lesson-progress.entity';
import { UserExerciseProgress } from './entities/user-exercise-progress.entity';
import { ProgressController } from './progress.controller';
import { ProgressService } from './progress.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      UserProgress,
      UserModuleProgress,
      UserLessonProgress,
      UserExerciseProgress,
    ]),
    UsersModule,
  ],
  controllers: [ProgressController],
  providers: [ProgressService],
  exports: [ProgressService],
})
export class ProgressModule {}
