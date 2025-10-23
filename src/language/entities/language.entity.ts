import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  OneToMany,
  CreateDateColumn,
} from 'typeorm';
import { LessonModule } from '../../lesson-module/entities/lesson-module.entity';
import { UserLanguage } from '../../users/entities/user-language.entity';
import { AlphabetItem } from '/types/language.types';

@Entity()
export class Language {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  code: string;

  @Column()
  name: string;

  @Column('json')
  alphabet: AlphabetItem[];

  @CreateDateColumn()
  createdAt: Date;

  @OneToMany(() => LessonModule, (module) => module.language)
  modules: LessonModule[];

  @OneToMany(() => UserLanguage, (ul) => ul.language)
  userLanguages: UserLanguage[];
}
