import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';
import { UserLanguage } from './user-language.entity';
import { LessonModule } from '../../lesson-module/entities/lesson-module.entity';

@Entity()
export class UserModuleProgress {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => UserLanguage, (ul) => ul.moduleProgresses, {
    onDelete: 'CASCADE',
  })
  userLanguage: UserLanguage;

  @ManyToOne(() => LessonModule, (module) => module.progresses, {
    onDelete: 'CASCADE',
  })
  module: LessonModule;

  @Column({ nullable: true })
  completedAt?: Date;

  @Column({ default: 0 })
  score: number; // процент или баллы

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
