import { IsArray, IsNumber, IsOptional, IsString } from 'class-validator';

export class UpdateModuleDto {
  @IsOptional()
  @IsString()
  title?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsNumber()
  languageId?: number;

  @IsOptional()
  @IsArray()
  @IsNumber({}, { each: true })
  lessonIds?: number[];
}
