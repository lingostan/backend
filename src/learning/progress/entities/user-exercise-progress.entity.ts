import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
} from 'typeorm';
import { User } from '../../../users/entities/user.entity';
import { Exercise } from '../../exercises/entities/exercise.entity';

@Entity('user_exercise_progress')
export class UserExerciseProgress {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  user: User;

  @ManyToOne(() => Exercise, { eager: true })
  exercise: Exercise;

  @Column({ default: false })
  completed: boolean;

  @Column({ type: 'int', default: 0 })
  score: number;

  @Column({ type: 'int', default: 0 })
  attempts: number;

  @Column({ type: 'jsonb', nullable: true })
  userAnswers: any[];

  @Column({ type: 'int', default: 0 })
  timeSpent: number;

  @CreateDateColumn()
  startedAt: Date;

  @Column({ nullable: true })
  completedAt: Date;
}
