import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';

import { Lesson } from './entities/lesson.entity';
import { User } from '../../users/entities/user.entity';
import { UserLessonProgress } from '../progress/entities/user-lesson-progress.entity';
import { ExercisesService } from '../exercises/exercises.service';
import { Mods } from '../mods/entities/mods.entity';
import { CreateLessonDto } from './dto/create-lesson.dto';
import { Exercise } from '../exercises/entities/exercise.entity';
import { UpdateLessonDto } from './dto/update-lesson.dto';

@Injectable()
export class LessonsService {
  constructor(
    @InjectRepository(Mods)
    private readonly moduleRepository: Repository<Mods>,
    @InjectRepository(Lesson)
    private readonly lessonRepository: Repository<Lesson>,
    @InjectRepository(Exercise)
    private readonly exerciseRepository: Repository<Exercise>,
    @InjectRepository(UserLessonProgress)
    private readonly userLessonProgressRepository: Repository<UserLessonProgress>,
    private readonly exercisesService: ExercisesService,
  ) {}

  async getAllLessons(moduleId?: number): Promise<Lesson[]> {
    const where: any = {};

    if (moduleId) {
      where.mods = { id: moduleId };
    }

    return await this.lessonRepository.find({
      where,
      relations: ['mods', 'exercises'],
      order: { order: 'ASC' },
    });
  }

  async createLesson(createLessonDto: CreateLessonDto): Promise<Lesson> {
    const lessonData: any = {
      ...createLessonDto,
    };

    const module = await this.moduleRepository.findOne({
      where: { id: createLessonDto.moduleId },
    });

    if (!module) {
      throw new NotFoundException(
        `Module with ID ${createLessonDto.moduleId} not found`,
      );
    }

    lessonData.mods = module;

    delete lessonData.moduleId;
    delete lessonData.exerciseIds;

    const lesson = this.lessonRepository.create(lessonData);
    const savedLesson = (await this.lessonRepository.save(
      lesson,
    )) as unknown as Lesson;

    if (createLessonDto.exerciseIds && createLessonDto.exerciseIds.length > 0) {
      await this.linkExercisesToLesson(
        savedLesson.id,
        createLessonDto.exerciseIds,
      );
    }

    return this.lessonRepository.findOne({
      where: { id: savedLesson.id },
      relations: ['mods', 'exercises'],
    });
  }

  async updateLesson(
    id: number,
    updateLessonDto: UpdateLessonDto,
  ): Promise<Lesson> {
    const lesson = await this.lessonRepository.findOne({
      where: { id },
      relations: ['mods', 'exercises'],
    });

    if (!lesson) {
      throw new NotFoundException(`Lesson with ID ${id} not found`);
    }

    const updateData: any = { ...updateLessonDto };

    console.log(updateData);

    if (updateLessonDto.moduleId) {
      const module = await this.moduleRepository.findOne({
        where: { id: updateLessonDto.moduleId },
      });

      if (!module) {
        throw new NotFoundException(
          `Module with ID ${updateLessonDto.moduleId} not found`,
        );
      }

      updateData.mods = module;
    }

    if (updateLessonDto.exerciseIds !== undefined) {
      await this.unlinkExercisesFromLesson(id);

      if (updateLessonDto.exerciseIds.length > 0) {
        await this.linkExercisesToLesson(id, updateLessonDto.exerciseIds);
      }
    }

    delete updateData.moduleId;
    delete updateData.exerciseIds;
    delete updateData.exercises;
    delete updateData.mods;

    await this.lessonRepository.update(id, updateData);

    return this.lessonRepository.findOne({
      where: { id },
      relations: ['mods', 'exercises'],
    });
  }

  private async unlinkExercisesFromLesson(lessonId: number): Promise<void> {
    await this.exerciseRepository
      .createQueryBuilder()
      .update(Exercise)
      .set({ lesson: null })
      .where('lessonId = :lessonId', { lessonId })
      .execute();
  }

  private async linkExercisesToLesson(
    lessonId: number,
    exerciseIds: number[],
  ): Promise<void> {
    const exercises = await this.exerciseRepository.findBy({
      id: In(exerciseIds),
    });

    if (exercises.length !== exerciseIds.length) {
      const foundIds = exercises.map((exercise) => exercise.id);
      const missingIds = exerciseIds.filter((id) => !foundIds.includes(id));
      console.warn(`Some exercises not found: ${missingIds.join(', ')}`);
    }

    for (const exercise of exercises) {
      exercise.lesson = { id: lessonId } as any;
      await this.exerciseRepository.save(exercise);
    }
  }

  async getLessonsWithProgress(
    userId: string,
    moduleId: number,
  ): Promise<Lesson[]> {
    const lessons = await this.lessonRepository.find({
      where: {
        mods: { id: moduleId },
        isActive: true,
      },
      relations: ['mods', 'mods.language', 'exercises', 'userProgress'],
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
      relations: ['mods', 'mods.language', 'exercises', 'userProgress'],
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

  async deleteLesson(lessonId: string) {
    await this.exerciseRepository
      .createQueryBuilder()
      .update(Exercise)
      .set({ lesson: null })
      .where('lessonId = :lessonId', { lessonId })
      .execute();

    await this.lessonRepository
      .createQueryBuilder()
      .delete()
      .from(Lesson)
      .where('id = :lessonId', { lessonId })
      .execute();
  }
}
