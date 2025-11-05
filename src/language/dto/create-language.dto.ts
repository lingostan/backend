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
  letter: string;

  @IsString()
  transcription: string;

  @IsOptional()
  audioUrl?: string;

  @IsOptional()
  @IsString()
  exampleWord?: string;

  @IsOptional()
  @IsString()
  exampleTranslation?: string;

  @IsOptional()
  @IsUrl()
  exampleImageUrl?: string;

  @IsNumber()
  @Min(0)
  order: number;
}

export class CreateLanguageDto {
  @IsString()
  @Length(2, 5)
  code: string;

  @IsString()
  name: string;

  @IsOptional()
  @IsString()
  flagEmoji?: string;

  @IsOptional()
  @IsUrl()
  flagUrl?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(5)
  difficulty?: number;

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @ArrayMinSize(1)
  @Type(() => CreateAlphabetItemDto)
  alphabet?: CreateAlphabetItemDto[];
}
