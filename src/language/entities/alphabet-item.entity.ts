import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Language } from './language.entity';

@Entity()
export class AlphabetItem {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Language, (language) => language.alphabet, {
    onDelete: 'CASCADE',
    nullable: false,
  })
  @JoinColumn({ name: 'languageId' })
  language: Language;

  @Column()
  letter: string;

  @Column()
  transcription: string;

  @Column({ nullable: true })
  audioUrl: string;

  @Column({ nullable: true })
  exampleWord: string;

  @Column({ nullable: true })
  exampleTranslation: string;

  @Column({ nullable: true })
  exampleImageUrl: string;

  @Column({ type: 'int' })
  order: number;
}
