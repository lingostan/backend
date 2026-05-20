import {
  IsString,
  IsEmail,
  Length,
  IsOptional,
  Matches,
} from 'class-validator';
import { LoginDto } from './login.dto';
import { ApiProperty } from '@nestjs/swagger';

enum Gender {
  MALE = 'male',
  FEMALE = 'female',
}

enum Role {
  USER = 'user',
  ADMIN = 'admin',
}

export class RegisterDto extends LoginDto {
  @IsString()
  @ApiProperty()
  name: string;

  @IsString()
  @IsOptional()
  @ApiProperty({
    required: false,
    enum: Role,
    example: Role.USER,
  })
  role: Role;

  @IsString()
  @IsOptional()
  @ApiProperty({
    enum: Gender,
    example: Gender.MALE,
  })
  sex: Gender;

  @IsString()
  @IsOptional()
  @ApiProperty()
  age: number;

  @IsOptional()
  @Matches(/^\+7\d{10}$/, {
    message: 'Phone must be in format +79999999999',
  })
  @ApiProperty({ required: false })
  phone?: string;

  @IsString()
  @IsOptional()
  @ApiProperty({ required: false })
  avatar: string;
}
