import { PartialType } from '@nestjs/mapped-types';
import {
  CreateLanguageDto,
  CreateAlphabetItemDto,
} from './create-language.dto';
import { IsArray, IsOptional, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty } from '@nestjs/swagger';

export class UpdateAlphabetItemDto extends CreateAlphabetItemDto {
  @IsOptional()
  @ApiProperty()
  id?: number;
}

export class UpdateLanguageDto extends PartialType(CreateLanguageDto) {
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => UpdateAlphabetItemDto)
  @ApiProperty({
    type: [UpdateAlphabetItemDto],
  })
  alphabet?: UpdateAlphabetItemDto[];
}
