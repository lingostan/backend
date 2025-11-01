import { Lesson } from '../../lessons/entities/lesson.entity';
import { VocabularyItemDto } from './vocabulary-item.dto';
import { ExercisePreviewDto } from '../../exercises/dto/exercise-preview.dto';
import { ModuleResponseDto } from '../../mods/dto/mods-response.dto';

export class LessonResponseDto {
  id: number;
  title: string;
  description: string;
  order: number;
  duration: number;
  videoUrl: string;
  vocabulary: VocabularyItemDto[];
  grammarNotes: string;
  isActive: boolean;
  mods: ModuleResponseDto;
  exercises: ExercisePreviewDto[];
  progress?: number;
  completed?: boolean;
  exerciseCount: number;
  totalPoints: number;
  createdAt: Date;

  constructor(lesson: Lesson) {
    this.id = lesson.id;
    this.title = lesson.title;
    this.description = lesson.description;
    this.order = lesson.order;
    this.duration = lesson.duration;
    this.videoUrl = lesson.videoUrl;
    this.vocabulary =
      lesson.vocabulary?.map((item) => new VocabularyItemDto(item)) || [];
    this.grammarNotes = lesson.grammarNotes;
    this.isActive = lesson.isActive;
    this.mods = new ModuleResponseDto(lesson.mods);
    this.exerciseCount = lesson.exercises?.length || 0;
    this.totalPoints =
      lesson.exercises?.reduce((total, ex) => total + ex.points, 0) || 0;
    this.createdAt = lesson.createdAt;

    if (lesson.exercises) {
      this.exercises = lesson.exercises.map((ex) => new ExercisePreviewDto(ex));
    }

    if (lesson.userProgress && lesson.userProgress.length > 0) {
      const progress = lesson.userProgress[0];
      this.progress = progress.progress;
      this.completed = progress.completed;
    }
  }
}
