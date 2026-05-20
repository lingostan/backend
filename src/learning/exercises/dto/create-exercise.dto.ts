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
import { ApiProperty } from '@nestjs/swagger';

export class CreateExerciseDto {
  @IsEnum(ExerciseType)
  @ApiProperty()
  type: ExerciseType;

  @IsString()
  @ApiProperty()
  title: string;

  @IsOptional()
  @IsString()
  @ApiProperty({ required: false })
  instructions?: string;

  @IsObject()
  @ApiProperty()
  content: any;

  @IsOptional()
  @IsNumber()
  @Min(1)
  @ApiProperty({ required: false })
  points?: number;

  @IsNumber()
  @Min(0)
  @ApiProperty()
  order: number;

  @IsOptional()
  @IsArray()
  @ApiProperty({ required: false })
  hints?: string[];

  @IsOptional()
  @IsString()
  @ApiProperty({ required: false })
  explanation?: string;

  @IsOptional()
  @IsNumber()
  @ApiProperty()
  lessonId?: number;

  @IsOptional()
  @IsNumber()
  @ApiProperty()
  languageId?: number;
}
