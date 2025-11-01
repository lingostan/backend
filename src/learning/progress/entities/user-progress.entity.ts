import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  UpdateDateColumn,
} from 'typeorm';
import { User } from '../../../users/entities/user.entity';
import { Language } from '../../../language/entities/language.entity';

@Entity('user_progress')
export class UserProgress {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  user: User;

  @ManyToOne(() => Language, { eager: true })
  language: Language;

  @Column({ type: 'decimal', precision: 5, scale: 2, default: 0 })
  overallProgress: number;

  @Column({ type: 'int', default: 0 })
  totalPoints: number;

  @Column({ type: 'int', default: 0 })
  completedExercises: number;

  @Column({ type: 'int', default: 0 })
  totalExercises: number;

  @Column({ type: 'int', default: 0 })
  completedLessons: number;

  @Column({ type: 'int', default: 0 })
  totalLessons: number;

  @Column({ type: 'int', default: 0 })
  completedModules: number;

  @Column({ type: 'int', default: 0 })
  totalModules: number;

  @Column({ type: 'int', default: 0 })
  streak: number;

  @Column({ type: 'int', default: 0 })
  dailyGoal: number;

  @Column({ type: 'int', default: 0 })
  dailyProgress: number;

  @UpdateDateColumn()
  lastActivityAt: Date;

  @Column({ type: 'date' })
  lastActivityDate: string;

  calculateOverallProgress(): number {
    if (this.totalExercises === 0) return 0;
    return (this.completedExercises / this.totalExercises) * 100;
  }

  updateDailyProgress(points: number): void {
    const today = new Date().toDateString();

    if (this.lastActivityDate !== today) {
      this.dailyProgress = 0;
      this.lastActivityDate = today;
    }

    this.dailyProgress += points;
    this.lastActivityAt = new Date();
  }

  updateStreak(): void {
    const today = new Date();
    const lastActivity = this.lastActivityAt
      ? new Date(this.lastActivityAt)
      : null;

    if (!lastActivity) {
      this.streak = 1;
    } else {
      const diffTime = Math.abs(today.getTime() - lastActivity.getTime());
      const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

      if (diffDays === 1) {
        this.streak++;
      } else if (diffDays > 1) {
        this.streak = 1;
      }
    }

    this.lastActivityAt = today;
    this.lastActivityDate = today.toDateString();
  }
}
