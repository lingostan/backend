import {
  IsString,
  IsNumber,
  IsEnum,
  IsOptional,
  IsArray,
  IsObject,
  Min,
  IsBoolean,
} from 'class-validator';
import { ExerciseType } from '../entities/exercise.entity';

export class CreateExerciseDto {
  @IsEnum(ExerciseType)
  type: ExerciseType;

  @IsString()
  title: string;

  @IsOptional()
  @IsString()
  instructions?: string;

  @IsObject()
  content: any;

  @IsOptional()
  @IsNumber()
  @Min(1)
  points?: number;

  @IsNumber()
  @Min(0)
  order: number;

  @IsOptional()
  @IsArray()
  hints?: string[];

  @IsOptional()
  @IsString()
  explanation?: string;

  @IsOptional()
  @IsNumber()
  lessonId?: number;

  @IsOptional()
  @IsNumber()
  languageId?: number;
}
