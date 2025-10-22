import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
} from 'typeorm';
import { LessonModule } from '../../lesson-module/entities/lesson-module.entity';

@Entity()
export class Question {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  type: 'multiple_choice' | 'text_input' | 'match'; // расширяемо

  @Column('text')
  questionText: string; // "How do you say 'hello'?"

  @Column('text')
  correctAnswer: string; // или JSON, если сложнее

  @Column('json', { nullable: true })
  options?: string[]; // для multiple_choice: ["hola", "adios", ...]

  @ManyToOne(() => LessonModule, (module) => module.questions, {
    onDelete: 'CASCADE',
  })
  module: LessonModule;

  @CreateDateColumn()
  createdAt: Date;
}
