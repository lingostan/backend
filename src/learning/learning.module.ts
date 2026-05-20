import { forwardRef, Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ModsModule } from './mods/mods.module';
import { LessonsModule } from './lessons/lessons.module';
import { ExercisesModule } from './exercises/exercises.module';
import { ProgressModule } from './progress/progress.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([]),
    forwardRef(() => LessonsModule),
    forwardRef(() => ModsModule),

    ExercisesModule,
    ProgressModule,
  ],
  controllers: [],
  providers: [],
  exports: [],
})
export class LearningModule {}
