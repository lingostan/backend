import { ApiProperty } from '@nestjs/swagger';
import { Language } from '../entities/language.entity';
import { AlphabetItemDto } from './alphabet-item.dto';
import { Mods } from '/learning/mods/entities/mods.entity';

export class LanguageResponseDto {
  @ApiProperty()
  id: number;
  @ApiProperty()
  code: string;
  @ApiProperty()
  name: string;
  @ApiProperty()
  flagEmoji: string;
  @ApiProperty()
  flagUrl: string;
  @ApiProperty()
  description: string;
  @ApiProperty()
  difficulty: number;
  @ApiProperty()
  isActive: boolean;
  @ApiProperty()
  totalModules: number;
  @ApiProperty()
  totalExercises: number;
  @ApiProperty()
  createdAt: Date;
  @ApiProperty({
    type: [AlphabetItemDto],
  })
  alphabet: AlphabetItemDto[];
  @ApiProperty({
    type: 'array',
    items: {
      type: 'object',
    },
  })
  mods: Mods[];

  constructor(language: Language) {
    this.id = language.id;
    this.code = language.code;
    this.name = language.name;
    this.flagEmoji = language.flagEmoji;
    this.flagUrl = language.flagUrl;
    this.description = language.description;
    this.difficulty = language.difficulty;
    this.isActive = language.isActive;
    this.totalModules = language.totalModules;
    this.totalExercises = language.totalExercises;
    this.createdAt = language.createdAt;
    this.alphabet = language.alphabet;
    this.mods = language.mods;
  }
}
