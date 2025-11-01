export class ProgressStatsDto {
  totalLanguages: number;
  totalPoints: number;
  totalExercisesCompleted: number;
  totalLessonsCompleted: number;
  totalModulesCompleted: number;
  currentStreak: number;
  longestStreak: number;
  totalTimeSpent: number;
  level: number;
  nextLevelPoints: number;
  dailyGoal: number;
  dailyProgress: number;

  constructor(stats: ProgressStatsDto) {
    this.totalLanguages = stats.totalLanguages;
    this.totalPoints = stats.totalPoints;
    this.totalExercisesCompleted = stats.totalExercisesCompleted;
    this.totalLessonsCompleted = stats.totalLessonsCompleted;
    this.totalModulesCompleted = stats.totalModulesCompleted;
    this.currentStreak = stats.currentStreak;
    this.longestStreak = stats.longestStreak;
    this.totalTimeSpent = stats.totalTimeSpent;
    this.level = stats.level;
    this.nextLevelPoints = stats.nextLevelPoints;
    this.dailyGoal = stats.dailyGoal;
    this.dailyProgress = stats.dailyProgress;
  }
}
