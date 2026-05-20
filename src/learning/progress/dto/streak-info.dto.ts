export class StreakInfoDto {
  currentStreak: number;
  longestStreak: number;
  lastActivityDate: Date;
  isTodayCompleted: boolean;

  constructor(streakInfo: StreakInfoDto) {
    this.currentStreak = streakInfo.currentStreak;
    this.longestStreak = streakInfo.longestStreak;
    this.lastActivityDate = streakInfo.lastActivityDate;
    this.isTodayCompleted = streakInfo.isTodayCompleted;
  }
}
