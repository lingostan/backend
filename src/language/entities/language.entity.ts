import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  OneToMany,
  CreateDateColumn,
} from 'typeorm';
import { Mods } from '../../learning/mods/entities/mods.entity';
import { AlphabetItem } from './alphabet-item.entity';
import { VocabularyItem } from '/learning/lessons/entities/lesson.entity';

@Entity()
export class Language {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  code: string;

  @Column()
  name: string;

  @Column({ nullable: true })
  flagEmoji: string;

  @Column({ nullable: true })
  flagUrl: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ default: 0 })
  difficulty: number; // 1-5

  @Column({ default: true })
  isActive: boolean;

  @Column({ default: 0 })
  totalModules: number;

  @Column({ default: 0 })
  totalExercises: number;

  @OneToMany(() => AlphabetItem, (alphabetItem) => alphabetItem.language, {
    cascade: true,
  })
  alphabet: AlphabetItem[];

  @OneToMany(() => Mods, (module) => module.language)
  mods: Mods[];

  @Column({ type: 'jsonb', nullable: true })
  vocabulary: VocabularyItem[];

  @CreateDateColumn()
  createdAt: Date;
}
