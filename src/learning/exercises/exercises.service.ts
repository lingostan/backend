import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Exercise } from './entities/exercise.entity';
import { CompleteExerciseDto } from './dto/complete-exercise.dto';
import { UsersService } from '../../users/users.service';
import { User } from '../../users/entities/user.entity';
import { UserExerciseProgress } from '../progress/entities/user-exercise-progress.entity';
import { ProgressService } from '../progress/progress.service';

@Injectable()
export class ExercisesService {
  constructor(
    @InjectRepository(Exercise)
    private readonly exerciseRepository: Repository<Exercise>,
    @InjectRepository(UserExerciseProgress)
    private readonly userExerciseProgressRepository: Repository<UserExerciseProgress>,
    private readonly progressService: ProgressService,
    private readonly usersService: UsersService,
  ) {}

  async getExercisesWithProgress(
    userId: string,
    lessonId: number,
  ): Promise<Exercise[]> {
    const exercises = await this.exerciseRepository.find({
      where: {
        lesson: { id: lessonId },
        isActive: true,
      },
      relations: ['lesson', 'lesson.module', 'userProgress'],
      order: { order: 'ASC' },
    });

    for (const exercise of exercises) {
      const progress = await this.getUserExerciseProgress(userId, exercise.id);
      exercise.userProgress = progress ? [progress] : [];
    }

    return exercises;
  }

  async getExerciseWithProgress(
    userId: string,
    exerciseId: number,
  ): Promise<Exercise> {
    const exercise = await this.exerciseRepository.findOne({
      where: { id: exerciseId },
      relations: ['lesson', 'lesson.module', 'userProgress'],
    });

    if (!exercise) {
      throw new NotFoundException(`Exercise with ID ${exerciseId} not found`);
    }

    const progress = await this.getUserExerciseProgress(userId, exerciseId);
    exercise.userProgress = progress ? [progress] : [];

    return exercise;
  }

  async getUserExerciseProgress(
    userId: string,
    exerciseId: number,
  ): Promise<UserExerciseProgress | null> {
    return this.userExerciseProgressRepository.findOne({
      where: {
        user: { id: userId },
        exercise: { id: exerciseId },
      },
    });
  }

  async completeExercise(
    userId: string,
    exerciseId: number,
    completeExerciseDto: CompleteExerciseDto,
  ): Promise<any> {
    const exercise = await this.getExerciseWithProgress(userId, exerciseId);
    let progress = await this.getUserExerciseProgress(userId, exerciseId);

    // Валидируем ответ
    const validationResult = exercise.validateAnswer(
      completeExerciseDto.userAnswer,
    );

    if (!progress) {
      progress = this.userExerciseProgressRepository.create({
        user: { id: userId } as User,
        exercise: { id: exerciseId } as Exercise,
        completed: validationResult.correct,
        score: validationResult.score,
        attempts: 1,
        userAnswers: [completeExerciseDto.userAnswer],
        timeSpent: completeExerciseDto.timeSpent || 0,
        startedAt: new Date(),
        completedAt: validationResult.correct ? new Date() : null,
      });
    } else {
      progress.attempts++;
      progress.score = Math.max(progress.score, validationResult.score);
      progress.completed = progress.completed || validationResult.correct;
      progress.userAnswers.push(completeExerciseDto.userAnswer);
      progress.timeSpent += completeExerciseDto.timeSpent || 0;

      if (validationResult.correct && !progress.completedAt) {
        progress.completedAt = new Date();
      }
    }

    await this.userExerciseProgressRepository.save(progress);

    // Обновляем общий прогресс
    if (validationResult.correct) {
      await this.updateUserProgress(userId, exercise, validationResult.score);
    }

    return {
      exerciseId,
      ...validationResult,
      completed: progress.completed,
      attempts: progress.attempts,
      totalScore: progress.score,
    };
  }

  async getExerciseHints(exerciseId: number): Promise<string[]> {
    const exercise = await this.exerciseRepository.findOne({
      where: { id: exerciseId },
    });

    if (!exercise) {
      throw new NotFoundException(`Exercise with ID ${exerciseId} not found`);
    }

    return exercise.hints || [];
  }

  async getExerciseProgress(
    userId: string,
    exerciseId: number,
  ): Promise<{ completed: boolean; score: number; attempts: number }> {
    const progress = await this.getUserExerciseProgress(userId, exerciseId);

    if (!progress) {
      return { completed: false, score: 0, attempts: 0 };
    }

    return {
      completed: progress.completed,
      score: progress.score,
      attempts: progress.attempts,
    };
  }

  async calculateLessonProgress(
    userId: string,
    lessonId: number,
  ): Promise<{ completed: number; total: number; percentage: number }> {
    const exercises = await this.exerciseRepository.find({
      where: { lesson: { id: lessonId } },
    });

    const totalExercises = exercises.length;
    let completedExercises = 0;

    for (const exercise of exercises) {
      const progress = await this.getUserExerciseProgress(userId, exercise.id);
      if (progress?.completed) {
        completedExercises++;
      }
    }

    const percentage =
      totalExercises > 0 ? (completedExercises / totalExercises) * 100 : 0;

    return {
      completed: completedExercises,
      total: totalExercises,
      percentage: Math.round(percentage),
    };
  }

  async getCompletedExercisesCount(
    userId: string,
    lessonId: number,
  ): Promise<number> {
    const result = await this.userExerciseProgressRepository
      .createQueryBuilder('progress')
      .innerJoin('progress.exercise', 'exercise')
      .innerJoin('exercise.lesson', 'lesson')
      .where('progress.user.id = :userId', { userId })
      .andWhere('lesson.id = :lessonId', { lessonId })
      .andWhere('progress.completed = :completed', { completed: true })
      .getCount();

    return result;
  }

  private async updateUserProgress(
    userId: string,
    exercise: Exercise,
    score: number,
  ): Promise<void> {
    try {
      // Получаем язык из урока через модуль
      const exerciseWithLanguage = await this.exerciseRepository.findOne({
        where: { id: exercise.id },
        relations: ['lesson', 'lesson.module', 'lesson.module.language'],
      });

      if (exerciseWithLanguage && exerciseWithLanguage.lesson.mods.language) {
        const languageId = exerciseWithLanguage.lesson.mods.language.id;

        // Обновляем прогресс языка пользователя
        await this.usersService.updateUserLanguageProgress(
          userId,
          languageId,
          0, // Прогресс будет пересчитан отдельно
          score,
        );

        // Обновляем общий прогресс через ProgressService
        await this.progressService.updateUserProgress(userId, languageId);
      }
    } catch (error) {
      console.error('Error updating user progress:', error);
    }
  }
}
