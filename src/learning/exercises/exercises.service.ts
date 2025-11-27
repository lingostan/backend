import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Exercise, ExerciseType } from './entities/exercise.entity';
import { CompleteExerciseDto } from './dto/complete-exercise.dto';
import { UsersService } from '../../users/users.service';
import { User } from '../../users/entities/user.entity';
import { UserExerciseProgress } from '../progress/entities/user-exercise-progress.entity';
import { ProgressService } from '../progress/progress.service';
import { CreateExerciseDto } from './dto/create-exercise.dto';
import { Language } from '/language/entities/language.entity';
import { Lesson } from '../lessons/entities/lesson.entity';
import { UpdateExerciseDto } from './dto/update-exercise.dto';

@Injectable()
export class ExercisesService {
  constructor(
    @InjectRepository(Exercise)
    private readonly exerciseRepository: Repository<Exercise>,
    @InjectRepository(Language)
    private readonly languageRepository: Repository<Language>,
    @InjectRepository(Lesson)
    private readonly lessonRepository: Repository<Lesson>,
    @InjectRepository(UserExerciseProgress)
    private readonly userExerciseProgressRepository: Repository<UserExerciseProgress>,
    private readonly progressService: ProgressService,
    private readonly usersService: UsersService,
  ) {}

  async getAllExercises(languageId?: number, type?: ExerciseType) {
    const where: any = {};

    if (languageId) {
      where.language = { id: languageId };
    }

    if (type) {
      where.type = type;
    }

    return await this.exerciseRepository.find({
      where,
      relations: ['lesson'],
    });
  }

  async createExercise(createExerciseDto: CreateExerciseDto): Promise<any> {
    const exerciseData: any = {
      ...createExerciseDto,
    };

    const lang = await this.languageRepository.findOne({
      where: { id: createExerciseDto.languageId },
    });

    if (createExerciseDto.lessonId) {
      const lesson = await this.lessonRepository.findOne({
        where: { id: createExerciseDto.lessonId },
      });

      exerciseData.lesson = lesson;
    }

    if (createExerciseDto.languageId) {
      exerciseData.language = lang;
    }

    delete exerciseData.lessonId;
    delete exerciseData.languageId;

    const exercise = this.exerciseRepository.create(exerciseData);
    const savedExercise = await this.exerciseRepository.save(exercise);

    return savedExercise as unknown as Exercise;
  }

  async updateExercise(
    id: number,
    updateExerciseDto: UpdateExerciseDto,
  ): Promise<Exercise> {
    await this.exerciseRepository.delete(2);

    const exercise = await this.exerciseRepository.findOne({
      where: { id },
      relations: ['language', 'lesson'],
    });

    if (!exercise) {
      throw new NotFoundException(`Exercise with ID ${id} not found`);
    }

    const updateData: any = { ...updateExerciseDto };

    if (updateExerciseDto.languageId) {
      const lang = await this.languageRepository.findOne({
        where: { id: updateExerciseDto.languageId },
      });

      if (!lang) {
        throw new NotFoundException(
          `Language with ID ${updateExerciseDto.languageId} not found`,
        );
      }

      updateData.language = lang;
    }

    if (updateExerciseDto.lessonId) {
      const lesson = await this.lessonRepository.findOne({
        where: { id: updateExerciseDto.lessonId },
      });

      if (!lesson) {
        throw new NotFoundException(
          `Lesson with ID ${updateExerciseDto.lessonId} not found`,
        );
      }

      updateData.lesson = lesson;
    }

    delete updateData.lessonId;
    delete updateData.language;
    delete updateData.languageId;

    await this.exerciseRepository.update(id, updateData);

    return this.exerciseRepository.findOne({
      where: { id },
      relations: ['language', 'lesson'],
    });
  }

  async getExercisesWithProgress(
    userId: string,
    lessonId: number,
  ): Promise<Exercise[]> {
    const exercises = await this.exerciseRepository.find({
      where: {
        lesson: { id: lessonId },
        isActive: true,
      },
      relations: ['lesson', 'lesson.mods', 'userProgress'],
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
      relations: ['lesson', 'lesson.mods', 'userProgress'],
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

  async deleteExercise(id: number) {
    await this.exerciseRepository.delete(id);
  }
}
