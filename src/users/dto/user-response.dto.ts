import { User } from '../entities/user.entity';
import { UserLanguageDto } from './user-language.dto';

export class UserResponseDto {
  id: string;
  email: string;
  name: string;
  avatarUrl: string;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
  languages: UserLanguageDto[];
  age: number;
  sex: 'male' | 'female';
  phone: string;

  constructor(user: User) {
    this.id = user.id;
    this.email = user.email;
    this.name = user.name;
    this.avatarUrl = user.avatarUrl;
    this.isActive = user.isActive;
    this.createdAt = user.createdAt;
    this.updatedAt = user.updatedAt;
    this.age = user.age;
    this.sex = user.sex;
    this.phone = user.phone;

    this.languages =
      user.languages?.map((lang) => new UserLanguageDto(lang)) || [];
  }
}
