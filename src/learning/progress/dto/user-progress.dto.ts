import { UserProgress } from '../entities/user-progress.entity';
import { LanguageResponseDto } from '../../../language/dto/language-response.dto';

export class UserProgressDto {
  language: LanguageResponseDto;
  overallProgress: number;
  totalPoints: number;
  completedExercises: number;
  totalExercises: number;
  completedLessons: number;
  totalLessons: number;
  completedModules: number;
  totalModules: number;
  streak: number;
  dailyGoal: number;
  dailyProgress: number;
  lastActivityAt: Date;
  level: number;

  constructor(progress: UserProgress) {
    this.language = new LanguageResponseDto(progress.language);
    this.overallProgress = progress.overallProgress;
    this.totalPoints = progress.totalPoints;
    this.completedExercises = progress.completedExercises;
    this.totalExercises = progress.totalExercises;
    this.completedLessons = progress.completedLessons;
    this.totalLessons = progress.totalLessons;
    this.completedModules = progress.completedModules;
    this.totalModules = progress.totalModules;
    this.streak = progress.streak;
    this.dailyGoal = progress.dailyGoal;
    this.dailyProgress = progress.dailyProgress;
    this.lastActivityAt = progress.lastActivityAt;
    this.level = this.calculateLevel(progress.totalPoints);
  }

  private calculateLevel(points: number): number {
    return Math.floor(points / 100) + 1;
  }
}
