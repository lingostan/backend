import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsNumber, IsOptional, IsString } from 'class-validator';

export class UpdateModuleDto {
  @IsOptional()
  @IsString()
  @ApiProperty({
    required: false,
  })
  title?: string;

  @IsOptional()
  @IsString()
  @ApiProperty({
    required: false,
  })
  description?: string;

  @IsOptional()
  @IsNumber()
  @ApiProperty({
    required: false,
  })
  languageId?: number;

  @IsOptional()
  @IsArray()
  @IsNumber({}, { each: true })
  @ApiProperty({
    required: false,
    type: [Number],
  })
  lessonIds?: number[];
}
