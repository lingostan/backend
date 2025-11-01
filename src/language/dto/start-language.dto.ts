import { IsString } from 'class-validator';

export class StartLanguageDto {
  @IsString()
  languageId: number;
}
