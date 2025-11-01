import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { UsersModule } from '../../users/users.module';
import { Exercise } from './entities/exercise.entity';
import { UserExerciseProgress } from '../progress/entities/user-exercise-progress.entity';
import { ProgressModule } from '../progress/progress.module';
import { ExercisesController } from './exercises.controller';
import { ExercisesService } from './exercises.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([Exercise, UserExerciseProgress]),
    ProgressModule,
    UsersModule,
  ],
  controllers: [ExercisesController],
  providers: [ExercisesService],
  exports: [ExercisesService],
})
export class ExercisesModule {}
