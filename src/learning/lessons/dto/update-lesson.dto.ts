import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsOptional, IsString, IsNumber } from 'class-validator';

export class UpdateLessonDto {
  @IsOptional()
  @IsString()
  @ApiProperty({ required: false })
  title?: string;

  @IsOptional()
  @IsString()
  @ApiProperty({ required: false })
  description?: string;

  @IsOptional()
  @IsNumber()
  @ApiProperty({ required: false })
  moduleId?: number;

  @IsOptional()
  @IsArray()
  @IsNumber({}, { each: true })
  @ApiProperty({
    required: false,
    type: [Number],
  })
  exerciseIds?: number[];
}
