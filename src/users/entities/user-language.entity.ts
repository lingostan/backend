import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
} from 'typeorm';
import { User } from './user.entity';
import { Language } from '../../language/entities/language.entity';

@Entity()
export class UserLanguage {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User, (user) => user.languages, { onDelete: 'CASCADE' })
  user: User;

  @ManyToOne(() => Language, { eager: true })
  language: Language;

  @Column({ default: 1 })
  level: number;

  @Column({ type: 'decimal', precision: 5, scale: 2, default: 0 })
  progress: number;

  @Column({ default: true })
  isActive: boolean;

  @Column({ type: 'int', default: 0 })
  totalPoints: number;

  @Column({ type: 'int', default: 0 })
  streak: number;

  @CreateDateColumn()
  startedAt: Date;

  @Column({ nullable: true })
  lastPracticedAt: Date;

  updateProgress(newProgress: number): void {
    this.progress = Math.min(100, Math.max(0, newProgress));
  }

  addPoints(points: number): void {
    this.totalPoints += points;
  }

  updateStreak(): void {
    const today = new Date();
    const lastPractice = this.lastPracticedAt
      ? new Date(this.lastPracticedAt)
      : null;

    if (!lastPractice || this.isConsecutiveDay(lastPractice, today)) {
      this.streak++;
    } else {
      this.streak = 1;
    }

    this.lastPracticedAt = today;
  }

  private isConsecutiveDay(date1: Date, date2: Date): boolean {
    const diffTime = Math.abs(date2.getTime() - date1.getTime());
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays === 1;
  }
}
