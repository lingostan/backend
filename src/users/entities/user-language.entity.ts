import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
} from 'typeorm';
import { User } from './user.entity';
import { Language } from '../../language/entities/language.entity';
import { UserModuleProgress } from './user-module-progress.entity';

@Entity()
export class UserLanguage {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, (user) => user.languages, { onDelete: 'CASCADE' })
  user: User;

  @ManyToOne(() => Language, (language) => language.userLanguages, {
    onDelete: 'CASCADE',
  })
  language: Language;

  @Column({ default: 'not_started' })
  status: 'not_started' | 'in_progress' | 'completed';

  @Column({ nullable: true })
  currentModuleId?: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @OneToMany(() => UserModuleProgress, (progress) => progress.userLanguage)
  moduleProgresses: UserModuleProgress[];
}
