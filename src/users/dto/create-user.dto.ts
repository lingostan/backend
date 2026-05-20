import { IsString, IsEmail, IsOptional, Length } from 'class-validator';
import { LoginDto } from '../../auth/dto/login.dto';

export class CreateUserDto extends LoginDto {
  @IsString()
  @Length(2, 100)
  name: string;

  @IsEmail()
  email: string;
}
