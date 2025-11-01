import { Lesson } from '../entities/lesson.entity';
import { VocabularyItemDto } from './vocabulary-item.dto';

export class LessonPreviewDto {
  id: number;
  title: string;
  description: string;
  order: number;
  duration: number;
  videoUrl: string;
  vocabulary: VocabularyItemDto[];
  grammarNotes: string;
  exerciseCount: number;
  totalPoints: number;
  completed?: boolean;
  progress?: number;
  startedAt?: Date;
  completedAt?: Date;

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
    this.exerciseCount = lesson.exercises?.length || 0;
    this.totalPoints =
      lesson.exercises?.reduce((total, ex) => total + (ex.points || 0), 0) || 0;

    if (lesson.userProgress && lesson.userProgress.length > 0) {
      const progress = lesson.userProgress[0];
      this.completed = progress.completed;
      this.progress = progress.progress;
      this.startedAt = progress.startedAt;
      this.completedAt = progress.completedAt;
    }
  }
}
