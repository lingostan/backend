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

import { AlphabetItem } from '../../types/language';
import { AlphabetItemDto } from './alphabet-item.dto';

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
  @Min(1)
  @Max(5)
  difficulty?: number;

  @IsArray()
  @ArrayMinSize(1)
  @ValidateNested({ each: true })
  @Type(() => AlphabetItemDto)
  alphabet: AlphabetItem[];
}
