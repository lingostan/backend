import {
  IsString,
  IsEmail,
  Length,
  IsOptional,
  Matches,
} from 'class-validator';
import { LoginDto } from './login.dto';

export class RegisterDto extends LoginDto {
  @IsString()
  name: string;

  @IsString()
  @IsOptional()
  role: 'user' | 'admin';

  @IsString()
  @IsOptional()
  sex: 'male' | 'female';

  @IsString()
  @IsOptional()
  age: number;

  @IsOptional()
  @Matches(/^\+7\d{10}$/, {
    message: 'Phone must be in format +79999999999',
  })
  phone?: string;
}
