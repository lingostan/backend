import {
  IsString,
  IsArray,
  IsNotEmpty,
  ArrayMinSize,
  ValidateNested,
} from 'class-validator';
import { AlphabetItem } from '/types/language.types';
import { AlphabetItemDto } from './alphabet-item.dto';
import { Type } from 'class-transformer';

export class CreateLanguageDto {
  @IsString()
  @IsNotEmpty()
  code: string;

  @IsString()
  @IsNotEmpty()
  name: string;

  @IsArray()
  @ArrayMinSize(1)
  @ValidateNested({ each: true })
  @Type(() => AlphabetItemDto)
  alphabet: AlphabetItem[];
}
