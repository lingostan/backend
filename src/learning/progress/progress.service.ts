import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { UserProgress } from './entities/user-progress.entity';
import { UserModuleProgress } from './entities/user-module-progress.entity';
import { UserLessonProgress } from './entities/user-lesson-progress.entity';
import { UserExerciseProgress } from './entities/user-exercise-progress.entity';
import { UsersService } from '../../users/users.service';

@Injectable()
export class ProgressService {
  constructor(
    @InjectRepository(UserProgress)
    private readonly userProgressRepository: Repository<UserProgress>,
    @InjectRepository(UserModuleProgress)
    private readonly userModuleProgressRepository: Repository<UserModuleProgress>,
    @InjectRepository(UserLessonProgress)
    private readonly userLessonProgressRepository: Repository<UserLessonProgress>,
    @InjectRepository(UserExerciseProgress)
    private readonly userExerciseProgressRepository: Repository<UserExerciseProgress>,
    private readonly usersService: UsersService,
  ) {}

  async getUserProgress(userId: string): Promise<UserProgress[]> {
    return this.userProgressRepository.find({
      where: { user: { id: userId } },
      relations: ['language'],
    });
  }

  async getLanguageProgress(
    userId: string,
    languageId: number,
  ): Promise<UserProgress> {
    let progress = await this.userProgressRepository.findOne({
      where: {
        user: { id: userId },
        language: { id: languageId },
      },
      relations: ['language'],
    });

    if (!progress) {
      progress = this.userProgressRepository.create({
        user: { id: userId } as any,
        language: { id: languageId } as any,
        dailyGoal: 50, // Default daily goal
        lastActivityDate: new Date().toDateString(),
      });
      await this.userProgressRepository.save(progress);
    }

    // Обновляем статистику
    await this.updateUserProgress(userId, languageId);

    return this.userProgressRepository.findOne({
      where: { id: progress.id },
      relations: ['language'],
    });
  }

  async updateUserProgress(userId: string, languageId: number): Promise<void> {
    const progress = await this.userProgressRepository.findOne({
      where: {
        user: { id: userId },
        language: { id: languageId },
      },
    });

    if (!progress) return;

    // Считаем статистику
    const exerciseStats = await this.getExerciseStats(userId, languageId);
    const lessonStats = await this.getLessonStats(userId, languageId);
    const moduleStats = await this.getModuleStats(userId, languageId);

    progress.completedExercises = exerciseStats.completed;
    progress.totalExercises = exerciseStats.total;
    progress.completedLessons = lessonStats.completed;
    progress.totalLessons = lessonStats.total;
    progress.completedModules = moduleStats.completed;
    progress.totalModules = moduleStats.total;
    progress.overallProgress = progress.calculateOverallProgress();

    await this.userProgressRepository.save(progress);
  }

  async getProgressStats(userId: string): Promise<any> {
    const userLanguages = await this.usersService.getUserLanguages(userId);
    const allProgress = await this.getUserProgress(userId);

    const totalPoints = allProgress.reduce((sum, p) => sum + p.totalPoints, 0);
    const totalExercisesCompleted = allProgress.reduce(
      (sum, p) => sum + p.completedExercises,
      0,
    );
    const totalLessonsCompleted = allProgress.reduce(
      (sum, p) => sum + p.completedLessons,
      0,
    );
    const totalModulesCompleted = allProgress.reduce(
      (sum, p) => sum + p.completedModules,
      0,
    );

    const currentStreak = Math.max(...allProgress.map((p) => p.streak));
    const level = this.calculateLevel(totalPoints);

    return {
      totalLanguages: userLanguages.length,
      totalPoints,
      totalExercisesCompleted,
      totalLessonsCompleted,
      totalModulesCompleted,
      currentStreak,
      longestStreak: currentStreak, // В реальности нужно хранить отдельно
      totalTimeSpent: 0, // Нужно считать из упражнений
      level,
      nextLevelPoints: level * 100 - totalPoints,
      dailyGoal: 50,
      dailyProgress: allProgress.reduce((sum, p) => sum + p.dailyProgress, 0),
    };
  }

  async getStreakInfo(userId: string): Promise<any> {
    const progress = await this.userProgressRepository.find({
      where: { user: { id: userId } },
    });

    const currentStreak = Math.max(...progress.map((p) => p.streak));
    const lastActivity = progress.reduce(
      (latest, p) => (p.lastActivityAt > latest ? p.lastActivityAt : latest),
      new Date(0),
    );

    const today = new Date().toDateString();
    const isTodayCompleted = progress.some(
      (p) => p.lastActivityDate === today && p.dailyProgress >= p.dailyGoal,
    );

    return {
      currentStreak,
      longestStreak: currentStreak,
      lastActivityDate: lastActivity,
      isTodayCompleted,
    };
  }

  async getDailyProgress(
    userId: string,
  ): Promise<{ goal: number; progress: number; completed: boolean }> {
    const progress = await this.userProgressRepository.find({
      where: { user: { id: userId } },
    });

    const totalGoal = 50; // Default daily goal
    const totalProgress = progress.reduce((sum, p) => sum + p.dailyProgress, 0);

    return {
      goal: totalGoal,
      progress: totalProgress,
      completed: totalProgress >= totalGoal,
    };
  }

  private async getExerciseStats(
    userId: string,
    languageId: number,
  ): Promise<{ completed: number; total: number }> {
    const completed = await this.userExerciseProgressRepository
      .createQueryBuilder('progress')
      .innerJoin('progress.exercise', 'exercise')
      .innerJoin('exercise.lesson', 'lesson')
      .innerJoin('lesson.module', 'module')
      .innerJoin('module.language', 'language')
      .where('progress.user.id = :userId', { userId })
      .andWhere('language.id = :languageId', { languageId })
      .andWhere('progress.completed = :completed', { completed: true })
      .getCount();

    const total = await this.userExerciseProgressRepository
      .createQueryBuilder('progress')
      .innerJoin('progress.exercise', 'exercise')
      .innerJoin('exercise.lesson', 'lesson')
      .innerJoin('lesson.module', 'module')
      .innerJoin('module.language', 'language')
      .where('language.id = :languageId', { languageId })
      .getCount();

    return { completed, total };
  }

  private async getLessonStats(
    userId: string,
    languageId: number,
  ): Promise<{ completed: number; total: number }> {
    const completed = await this.userLessonProgressRepository
      .createQueryBuilder('progress')
      .innerJoin('progress.lesson', 'lesson')
      .innerJoin('lesson.module', 'module')
      .innerJoin('module.language', 'language')
      .where('progress.user.id = :userId', { userId })
      .andWhere('language.id = :languageId', { languageId })
      .andWhere('progress.completed = :completed', { completed: true })
      .getCount();

    const total = await this.userLessonProgressRepository
      .createQueryBuilder('progress')
      .innerJoin('progress.lesson', 'lesson')
      .innerJoin('lesson.module', 'module')
      .innerJoin('module.language', 'language')
      .where('language.id = :languageId', { languageId })
      .getCount();

    return { completed, total };
  }

  private async getModuleStats(
    userId: string,
    languageId: number,
  ): Promise<{ completed: number; total: number }> {
    const completed = await this.userModuleProgressRepository
      .createQueryBuilder('progress')
      .innerJoin('progress.module', 'module')
      .innerJoin('module.language', 'language')
      .where('progress.user.id = :userId', { userId })
      .andWhere('language.id = :languageId', { languageId })
      .andWhere('progress.completed = :completed', { completed: true })
      .getCount();

    const total = await this.userModuleProgressRepository
      .createQueryBuilder('progress')
      .innerJoin('progress.module', 'module')
      .innerJoin('module.language', 'language')
      .where('language.id = :languageId', { languageId })
      .getCount();

    return { completed, total };
  }

  private calculateLevel(points: number): number {
    return Math.floor(points / 100) + 1;
  }
}
