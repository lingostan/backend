import { ApiProperty } from '@nestjs/swagger';
import {
  IsString,
  IsNumber,
  IsOptional,
  IsUrl,
  IsArray,
  Min,
} from 'class-validator';
import { VocabularyItemDto } from './vocabulary-item.dto';

export class CreateLessonDto {
  @IsString()
  @ApiProperty()
  title: string;

  @IsString()
  @ApiProperty()
  description: string;

  @IsNumber()
  @Min(0)
  @ApiProperty()
  order: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @ApiProperty({ required: false })
  duration?: number;

  @IsOptional()
  @IsUrl()
  @ApiProperty({ required: false })
  videoUrl?: string;

  @IsOptional()
  @IsArray()
  @ApiProperty({ required: false, type: [VocabularyItemDto] })
  vocabulary?: VocabularyItemDto[];

  @IsOptional()
  @IsString()
  @ApiProperty({ required: false })
  grammarNotes?: string;

  @IsNumber()
  @ApiProperty()
  moduleId: number;

  @IsNumber()
  @ApiProperty()
  languageId: number;

  @IsOptional()
  @IsArray()
  @IsNumber({}, { each: true })
  @ApiProperty({ required: false, type: [Number] })
  exerciseIds?: number[];
}
