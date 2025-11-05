import { PartialType } from '@nestjs/mapped-types';
import {
  CreateLanguageDto,
  CreateAlphabetItemDto,
} from './create-language.dto';
import { IsArray, IsOptional, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';

export class UpdateAlphabetItemDto extends CreateAlphabetItemDto {
  @IsOptional()
  id?: number; // Для существующих букв
}

export class UpdateLanguageDto extends PartialType(CreateLanguageDto) {
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => UpdateAlphabetItemDto)
  alphabet?: UpdateAlphabetItemDto[];
}
