import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
} from 'typeorm';
import { User } from '../../../users/entities/user.entity';
import { Lesson } from '../../lessons/entities/lesson.entity';

@Entity('user_lesson_progress')
export class UserLessonProgress {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  user: User;

  @ManyToOne(() => Lesson, {
    eager: true,
    nullable: true,
    onDelete: 'SET NULL',
  })
  lesson: Lesson;

  @Column({ default: false })
  completed: boolean;

  @Column({ type: 'decimal', precision: 5, scale: 2, default: 0 })
  progress: number;

  @Column({ type: 'int', default: 0 })
  score: number;

  @Column({ type: 'int', default: 0 })
  timeSpent: number;

  @CreateDateColumn()
  startedAt: Date;

  @Column({ nullable: true })
  completedAt: Date;
}
