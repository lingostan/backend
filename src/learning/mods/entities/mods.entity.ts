import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
  CreateDateColumn,
} from 'typeorm';
import { Lesson } from '../../lessons/entities/lesson.entity';
import { UserModuleProgress } from '../../progress/entities/user-module-progress.entity';
import { Language } from '../../../language/entities/language.entity';

@Entity('learning_modules')
export class Mods {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  title: string;

  @Column({ type: 'text' })
  description: string;

  @Column()
  order: number;

  @Column({ default: 'BEGINNER' })
  difficulty: 'BEGINNER' | 'INTERMEDIATE' | 'ADVANCED';

  @Column({ nullable: true })
  imageUrl: string;

  @Column({ type: 'int', default: 0 })
  estimatedDuration: number; // in minutes

  @Column({ type: 'int', default: 0 })
  totalLessons: number;

  @Column({ type: 'int', default: 0 })
  totalExercises: number;

  @Column({ default: true })
  isActive: boolean;

  @ManyToOne(() => Language, (language) => language.mods)
  language: Language;

  @OneToMany(() => Lesson, (lesson) => lesson.mods)
  lessons: Lesson[];

  @OneToMany(() => UserModuleProgress, (progress) => progress.mods)
  userProgress: UserModuleProgress[];

  @CreateDateColumn()
  createdAt: Date;

  updateStats(): void {
    this.totalLessons = this.lessons?.length || 0;
    this.totalExercises =
      this.lessons?.reduce(
        (total, lesson) => total + (lesson.exercises?.length || 0),
        0,
      ) || 0;
  }
}
