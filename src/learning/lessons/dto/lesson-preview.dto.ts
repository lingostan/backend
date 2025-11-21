import { ApiProperty } from '@nestjs/swagger';
import { Lesson } from '../entities/lesson.entity';
import { VocabularyItemDto } from './vocabulary-item.dto';

export class LessonPreviewDto {
  @ApiProperty()
  id: number;
  @ApiProperty()
  title: string;
  @ApiProperty()
  description: string;
  @ApiProperty()
  order: number;
  @ApiProperty()
  duration: number;
  @ApiProperty()
  videoUrl: string;
  @ApiProperty({
    type: [VocabularyItemDto],
  })
  vocabulary: VocabularyItemDto[];
  @ApiProperty()
  grammarNotes: string;
  @ApiProperty()
  exerciseCount: number;
  @ApiProperty()
  totalPoints: number;
  @ApiProperty()
  completed?: boolean;
  @ApiProperty()
  progress?: number;
  @ApiProperty()
  startedAt?: Date;
  @ApiProperty()
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
