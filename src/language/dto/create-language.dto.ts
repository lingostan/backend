import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsString,
  IsNumber,
  IsOptional,
  IsUrl,
  Min,
  Max,
  Length,
  IsArray,
  ArrayMinSize,
  ValidateNested,
} from 'class-validator';

export class CreateAlphabetItemDto {
  @IsString()
  @ApiProperty()
  letter: string;

  @IsString()
  @ApiProperty()
  transcription: string;

  @IsOptional()
  @ApiProperty()
  audioUrl?: string;

  @IsOptional()
  @IsString()
  @ApiProperty()
  exampleWord?: string;

  @IsOptional()
  @IsString()
  @ApiProperty()
  exampleTranslation?: string;

  @IsOptional()
  @IsUrl()
  @ApiProperty()
  exampleImageUrl?: string;

  @IsNumber()
  @Min(0)
  @ApiProperty()
  order: number;
}

export class CreateLanguageDto {
  @IsString()
  @Length(2, 5)
  @ApiProperty()
  code: string;

  @IsString()
  @ApiProperty()
  name: string;

  @IsOptional()
  @IsString()
  @ApiProperty({ required: false })
  flagEmoji?: string;

  @IsOptional()
  @IsUrl()
  @ApiProperty({ required: false })
  flagUrl?: string;

  @IsOptional()
  @IsString()
  @ApiProperty({ required: false })
  description?: string;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(5)
  @ApiProperty({ required: false })
  difficulty?: number;

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @ArrayMinSize(1)
  @Type(() => CreateAlphabetItemDto)
  @ApiProperty({
    type: [CreateAlphabetItemDto],
  })
  alphabet?: CreateAlphabetItemDto[];
}
