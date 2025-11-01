import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Lesson } from './entities/lesson.entity';
import { User } from '../../users/entities/user.entity';
import { UserLessonProgress } from '../progress/entities/user-lesson-progress.entity';
import { ExercisesService } from '../exercises/exercises.service';

@Injectable()
export class LessonsService {
  constructor(
    @InjectRepository(Lesson)
    private readonly lessonRepository: Repository<Lesson>,
    @InjectRepository(UserLessonProgress)
    private readonly userLessonProgressRepository: Repository<UserLessonProgress>,
    private readonly exercisesService: ExercisesService,
  ) {}

  async getLessonsWithProgress(
    userId: string,
    moduleId: number,
  ): Promise<Lesson[]> {
    const lessons = await this.lessonRepository.find({
      where: {
        mods: { id: moduleId },
        isActive: true,
      },
      relations: ['module', 'module.language', 'exercises', 'userProgress'],
      order: { order: 'ASC' },
    });

    for (const lesson of lessons) {
      const progress = await this.getUserLessonProgress(userId, lesson.id);
      lesson.userProgress = progress ? [progress] : [];
    }

    return lessons;
  }

  async getLessonWithProgress(
    userId: string,
    lessonId: number,
  ): Promise<Lesson> {
    const lesson = await this.lessonRepository.findOne({
      where: { id: lessonId },
      relations: ['module', 'module.language', 'exercises', 'userProgress'],
    });

    if (!lesson) {
      throw new NotFoundException(`Lesson with ID ${lessonId} not found`);
    }

    const progress = await this.getUserLessonProgress(userId, lessonId);
    lesson.userProgress = progress ? [progress] : [];

    return lesson;
  }

  async getUserLessonProgress(
    userId: string,
    lessonId: number,
  ): Promise<UserLessonProgress | null> {
    return this.userLessonProgressRepository.findOne({
      where: {
        user: { id: userId },
        lesson: { id: lessonId },
      },
    });
  }

  async startLesson(
    userId: string,
    lessonId: number,
  ): Promise<{ started: boolean }> {
    const progress = await this.getUserLessonProgress(userId, lessonId);

    if (!progress) {
      await this.userLessonProgressRepository.save({
        user: { id: userId } as User,
        lesson: { id: lessonId } as Lesson,
        progress: 0,
        completed: false,
        startedAt: new Date(),
      });
    }

    return { started: true };
  }

  async completeLesson(
    userId: string,
    lessonId: number,
  ): Promise<{ completed: boolean; progress: number }> {
    const lesson = await this.getLessonWithProgress(userId, lessonId);
    let progress = await this.getUserLessonProgress(userId, lessonId);

    // Рассчитываем прогресс на основе завершенных упражнений
    const exerciseProgress =
      await this.exercisesService.calculateLessonProgress(userId, lessonId);

    if (!progress) {
      progress = this.userLessonProgressRepository.create({
        user: { id: userId } as User,
        lesson: { id: lessonId } as Lesson,
        progress: exerciseProgress.percentage,
        completed: exerciseProgress.percentage === 100,
        completedAt: exerciseProgress.percentage === 100 ? new Date() : null,
      });
    } else {
      progress.progress = exerciseProgress.percentage;
      progress.completed = exerciseProgress.percentage === 100;
      progress.completedAt =
        exerciseProgress.percentage === 100 ? new Date() : null;
    }

    await this.userLessonProgressRepository.save(progress);

    return {
      completed: progress.completed,
      progress: progress.progress,
    };
  }

  async calculateLessonProgress(
    userId: string,
    lessonId: number,
  ): Promise<{ completed: number; total: number; percentage: number }> {
    const lesson = await this.getLessonWithProgress(userId, lessonId);
    const totalExercises = lesson.exercises.length;

    if (totalExercises === 0) {
      return { completed: 0, total: 0, percentage: 0 };
    }

    const completedExercises =
      await this.exercisesService.getCompletedExercisesCount(userId, lessonId);
    const percentage = (completedExercises / totalExercises) * 100;

    return {
      completed: completedExercises,
      total: totalExercises,
      percentage: Math.round(percentage),
    };
  }
}
