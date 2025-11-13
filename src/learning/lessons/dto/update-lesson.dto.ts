import { IsArray, IsOptional, IsString, IsNumber } from 'class-validator';

export class UpdateLessonDto {
  @IsOptional()
  @IsString()
  title?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsNumber()
  moduleId?: number;

  @IsOptional()
  @IsArray()
  @IsNumber({}, { each: true })
  exerciseIds?: number[];
}
