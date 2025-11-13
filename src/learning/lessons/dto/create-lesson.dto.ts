import {
  IsString,
  IsNumber,
  IsOptional,
  IsUrl,
  IsArray,
  Min,
} from 'class-validator';

export class CreateLessonDto {
  @IsString()
  title: string;

  @IsString()
  description: string;

  @IsNumber()
  @Min(0)
  order: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  duration?: number;

  @IsOptional()
  @IsUrl()
  videoUrl?: string;

  @IsOptional()
  @IsArray()
  vocabulary?: any[];

  @IsOptional()
  @IsString()
  grammarNotes?: string;

  @IsNumber()
  moduleId: number;

  @IsOptional()
  @IsArray()
  @IsNumber({}, { each: true })
  exerciseIds?: number[];
}
