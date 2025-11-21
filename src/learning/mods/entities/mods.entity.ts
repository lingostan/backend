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
import { ApiProperty } from '@nestjs/swagger';

@Entity('learning_modules')
export class Mods {
  @PrimaryGeneratedColumn()
  @ApiProperty()
  id: number;

  @Column()
  @ApiProperty()
  title: string;

  @Column({ type: 'text' })
  @ApiProperty()
  description: string;

  @Column()
  @ApiProperty()
  order: number;

  @Column({ default: 'BEGINNER' })
  @ApiProperty()
  difficulty: 'BEGINNER' | 'INTERMEDIATE' | 'ADVANCED';

  @Column({ nullable: true })
  @ApiProperty()
  imageUrl: string;

  @Column({ type: 'int', default: 0 })
  @ApiProperty()
  estimatedDuration: number; // in minutes

  @Column({ type: 'int', default: 0 })
  @ApiProperty()
  totalLessons: number;

  @Column({ type: 'int', default: 0 })
  @ApiProperty()
  totalExercises: number;

  @Column({ default: true })
  @ApiProperty()
  isActive: boolean;

  @ManyToOne(() => Language, (language) => language.mods)
  language: Language;

  @OneToMany(() => Lesson, (lesson) => lesson.mods)
  @ApiProperty()
  lessons: Lesson[];

  @OneToMany(() => UserModuleProgress, (progress) => progress.mods)
  @ApiProperty()
  userProgress: UserModuleProgress[];

  @CreateDateColumn()
  @ApiProperty()
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
