import { ApiProperty } from '@nestjs/swagger';
import {
  IsString,
  IsNumber,
  IsOptional,
  IsEnum,
  IsUrl,
  Min,
  IsArray,
} from 'class-validator';

enum Difficulty {
  BEGINNER = 'BEGINNER',
  INTERMEDIATE = 'INTERMEDIATE',
  ADVANCED = 'ADVANCED',
}
export class CreateModuleDto {
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

  @IsEnum(['BEGINNER', 'INTERMEDIATE', 'ADVANCED'])
  @ApiProperty({
    required: false,
    enum: Difficulty,
    example: Difficulty.BEGINNER,
  })
  difficulty: Difficulty;

  @IsOptional()
  @IsUrl()
  @ApiProperty({ required: false })
  imageUrl?: string;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @ApiProperty({ required: false })
  estimatedDuration?: number;

  @IsNumber()
  @ApiProperty()
  languageId: number;

  @IsOptional()
  @IsArray()
  @IsNumber({}, { each: true })
  @ApiProperty({ required: false, type: [Number] })
  lessonIds?: number[];
}
