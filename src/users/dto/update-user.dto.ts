import { IsString, IsOptional } from 'class-validator';
import { LoginDto } from '/auth/dto/login.dto';

export class UpdateUserDto {
  @IsString()
  @IsOptional()
  avatar: string;
}
