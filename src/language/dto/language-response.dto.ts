import { Language } from '../entities/language.entity';
import { AlphabetItemDto } from './alphabet-item.dto';

export class LanguageResponseDto {
  id: number;
  code: string;
  name: string;
  flagEmoji: string;
  flagUrl: string;
  description: string;
  difficulty: number;
  isActive: boolean;
  totalModules: number;
  totalExercises: number;
  createdAt: Date;
  alphabet: AlphabetItemDto[];

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
  }
}
