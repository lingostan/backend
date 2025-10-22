import { IsUUID } from 'class-validator';

export class StartLanguageDto {
  @IsUUID()
  languageId: string;
}
