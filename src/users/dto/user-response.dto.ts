import { ApiProperty } from '@nestjs/swagger';
import { User } from '../entities/user.entity';
import { UserLanguageDto } from './user-language.dto';

export class UserResponseDto {
  @ApiProperty()
  id: string;
  @ApiProperty()
  email: string;
  @ApiProperty()
  name: string;
  @ApiProperty()
  avatarUrl: string;
  @ApiProperty()
  isActive: boolean;
  @ApiProperty()
  createdAt: Date;
  @ApiProperty()
  updatedAt: Date;
  @ApiProperty({
    type: [UserLanguageDto],
  })
  languages: UserLanguageDto[];
  @ApiProperty()
  age: number;
  @ApiProperty()
  sex: 'male' | 'female';
  @ApiProperty()
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
