import { Lesson } from '../../lessons/entities/lesson.entity';
import { VocabularyItemDto } from './vocabulary-item.dto';
import { ExercisePreviewDto } from '../../exercises/dto/exercise-preview.dto';
import { ModuleResponseDto } from '../../mods/dto/mods-response.dto';
import { ApiProperty } from '@nestjs/swagger';

export class LessonResponseDto {
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
  isActive: boolean;
  @ApiProperty()
  modsId: number;
  @ApiProperty({
    type: [Number],
  })
  exercises: number[];
  @ApiProperty()
  progress?: number;
  @ApiProperty()
  completed?: boolean;
  @ApiProperty()
  exerciseCount: number;
  @ApiProperty()
  totalPoints: number;
  @ApiProperty()
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
    this.modsId = lesson.mods?.id || 0;
    this.exerciseCount = lesson.exercises?.length || 0;
    this.totalPoints =
      lesson.exercises?.reduce((total, ex) => total + ex.points, 0) || 0;
    this.createdAt = lesson.createdAt;

    if (lesson.exercises) {
      this.exercises = lesson.exercises.map((ex) => ex.id);
    }

    if (lesson.userProgress && lesson.userProgress.length > 0) {
      const progress = lesson.userProgress[0];
      this.progress = progress.progress;
      this.completed = progress.completed;
    }
  }
}
