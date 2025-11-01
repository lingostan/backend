import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
  CreateDateColumn,
} from 'typeorm';
import { Exercise } from '../../exercises/entities/exercise.entity';
import { UserLessonProgress } from '../../progress/entities/user-lesson-progress.entity';
import { Mods } from '../../mods/entities/mods.entity';

@Entity()
export class Lesson {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  title: string;

  @Column({ type: 'text' })
  description: string;

  @Column()
  order: number;

  @Column({ type: 'int', default: 0 })
  duration: number;

  @Column({ nullable: true })
  videoUrl: string;

  @Column({ type: 'jsonb', nullable: true })
  vocabulary: VocabularyItem[];

  @Column({ type: 'text', nullable: true })
  grammarNotes: string;

  @Column({ default: true })
  isActive: boolean;

  @ManyToOne(() => Mods, (mods) => mods.lessons)
  mods: Mods;

  @OneToMany(() => Exercise, (exercise) => exercise.lesson)
  exercises: Exercise[];

  @OneToMany(() => UserLessonProgress, (progress) => progress.lesson)
  userProgress: UserLessonProgress[];

  @CreateDateColumn()
  createdAt: Date;

  getExerciseCount(): number {
    return this.exercises?.length || 0;
  }

  getTotalPoints(): number {
    return (
      this.exercises?.reduce((total, exercise) => total + exercise.points, 0) ||
      0
    );
  }
}

export interface VocabularyItem {
  word: string;
  translation: string;
  pronunciation: string;
  audioUrl: string;
  imageUrl: string;
  partOfSpeech: string;
  example: string;
}
