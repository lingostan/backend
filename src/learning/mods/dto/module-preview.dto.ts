import { Mods } from '../entities/mods.entity';
import { LanguageResponseDto } from '../../../language/dto/language-response.dto';

export class ModulePreviewDto {
  id: number;
  title: string;
  description: string;
  order: number;
  difficulty: string;
  imageUrl: string;
  estimatedDuration: number;
  totalLessons: number;
  totalExercises: number;
  language: LanguageResponseDto;
  progress?: number;
  completed?: boolean;

  constructor(mods: Mods) {
    this.id = mods.id;
    this.title = mods.title;
    this.description = mods.description;
    this.order = mods.order;
    this.difficulty = mods.difficulty;
    this.imageUrl = mods.imageUrl;
    this.estimatedDuration = mods.estimatedDuration;
    this.totalLessons = mods.totalLessons;
    this.totalExercises = mods.totalExercises;
    this.language = new LanguageResponseDto(mods.language);

    if (mods.userProgress && mods.userProgress.length > 0) {
      const progress = mods.userProgress[0];
      this.progress = progress.progress;
      this.completed = progress.completed;
    }
  }
}
