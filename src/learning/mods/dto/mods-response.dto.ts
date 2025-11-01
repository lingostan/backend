import { Mods } from '../entities/mods.entity';
import { LanguageResponseDto } from '../../../language/dto/language-response.dto';
import { LessonPreviewDto } from '../../lessons/dto/lesson-preview.dto';

export class ModuleResponseDto {
  id: number;
  title: string;
  description: string;
  order: number;
  difficulty: string;
  imageUrl: string;
  estimatedDuration: number;
  totalLessons: number;
  totalExercises: number;
  isActive: boolean;
  language: LanguageResponseDto;
  progress?: number;
  completed?: boolean;
  lessons?: LessonPreviewDto[];
  createdAt: Date;

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
    this.isActive = mods.isActive;
    this.language = new LanguageResponseDto(mods.language);
    this.createdAt = mods.createdAt;

    if (mods.userProgress && mods.userProgress.length > 0) {
      const progress = mods.userProgress[0];
      this.progress = progress.progress;
      this.completed = progress.completed;
    }

    if (mods.lessons) {
      this.lessons = mods.lessons.map((lesson) => new LessonPreviewDto(lesson));
    }
  }
}
