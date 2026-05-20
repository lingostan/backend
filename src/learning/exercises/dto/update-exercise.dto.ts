import { ApiProperty } from '@nestjs/swagger';
import { IsNumber, IsObject, IsOptional, IsString } from 'class-validator';

export class UpdateExerciseDto {
  @IsOptional()
  @IsString()
  @ApiProperty()
  title?: string;

  @IsOptional()
  @IsObject()
  @ApiProperty()
  content?: any;

  @IsOptional()
  @IsNumber()
  @ApiProperty()
  languageId?: number;

  @IsOptional()
  @IsNumber()
  @ApiProperty()
  lessonId?: number;
}
