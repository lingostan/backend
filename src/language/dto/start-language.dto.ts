import { IsString } from 'class-validator';

export class StartLanguageDto {
  @IsString()
  code: string;
}
