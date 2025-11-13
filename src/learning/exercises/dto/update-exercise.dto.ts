import { IsNumber, IsObject, IsOptional, IsString } from 'class-validator';

export class UpdateExerciseDto {
  @IsOptional()
  @IsString()
  title?: string;

  @IsOptional()
  @IsObject()
  content?: any;

  @IsOptional()
  @IsNumber()
  languageId?: number;

  @IsOptional()
  @IsNumber()
  lessonId?: number;
}
