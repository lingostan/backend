import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
} from 'typeorm';
import { UserLanguage } from './user-language.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ length: 100 })
  name: string;

  @Column({ unique: true })
  email: string;

  @Column()
  password: string;

  @Column({ nullable: true })
  age?: number;

  @Column()
  sex: 'male' | 'female';

  @Column({ nullable: true })
  phone?: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @OneToMany(() => UserLanguage, (ul) => ul.user)
  languages: UserLanguage[];

  @Column({ default: 'user' })
  role: 'user' | 'admin';
}
