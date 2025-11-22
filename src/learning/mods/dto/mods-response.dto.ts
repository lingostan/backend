import { Mods } from '../entities/mods.entity';
import { LanguageResponseDto } from '../../../language/dto/language-response.dto';
import { LessonPreviewDto } from '../../lessons/dto/lesson-preview.dto';
import { ApiProperty } from '@nestjs/swagger';

export class ModuleResponseDto {
  @ApiProperty()
  id: number;
  @ApiProperty()
  title: string;
  @ApiProperty()
  description: string;
  @ApiProperty()
  order: number;
  @ApiProperty()
  difficulty: string;
  @ApiProperty()
  imageUrl: string;
  @ApiProperty()
  estimatedDuration: number;
  @ApiProperty()
  totalLessons: number;
  @ApiProperty()
  totalExercises: number;
  @ApiProperty()
  isActive: boolean;
  @ApiProperty()
  language: number;
  @ApiProperty()
  progress?: number;
  @ApiProperty()
  completed?: boolean;
  @ApiProperty({
    type: [Number],
  })
  lessons?: number[];
  @ApiProperty()
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
    this.language = mods.language.id;
    this.createdAt = mods.createdAt;

    if (mods.userProgress && mods.userProgress.length > 0) {
      const progress = mods.userProgress[0];
      this.progress = progress.progress;
      this.completed = progress.completed;
    }

    if (mods.lessons) {
      this.lessons = mods.lessons.map(({ id }) => id);
    }
  }
}
