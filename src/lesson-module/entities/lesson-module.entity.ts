import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
  CreateDateColumn,
} from 'typeorm';
import { Language } from '../../language/entities/language.entity';
import { Question } from '../../question/entities/question.entity';
import { UserModuleProgress } from '../../users/entities/user-module-progress.entity';

@Entity()
export class LessonModule {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  title: string; // "Greetings", "Food"

  @Column()
  order: number; // 1, 2, 3...

  @ManyToOne(() => Language, (language) => language.modules, {
    onDelete: 'CASCADE',
  })
  language: Language;

  @OneToMany(() => Question, (question) => question.module)
  questions: Question[];

  @OneToMany(() => UserModuleProgress, (progress) => progress.module)
  progresses: UserModuleProgress[];

  @CreateDateColumn()
  createdAt: Date;
}
