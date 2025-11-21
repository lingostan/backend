import { Exercise, ExerciseType } from '../entities/exercise.entity';
import { LessonPreviewDto } from '../../lessons/dto/lesson-preview.dto';
import { ApiProperty } from '@nestjs/swagger';

export class ExerciseResponseDto {
  @ApiProperty()
  id: number;
  @ApiProperty()
  type: ExerciseType;
  @ApiProperty()
  title: string;
  @ApiProperty()
  instructions: string;
  @ApiProperty()
  content: any;
  @ApiProperty()
  points: number;
  @ApiProperty()
  order: number;
  @ApiProperty()
  hints: string[];
  @ApiProperty()
  explanation: string;
  @ApiProperty()
  isActive: boolean;
  @ApiProperty()
  lesson: LessonPreviewDto;
  @ApiProperty()
  completed?: boolean;
  @ApiProperty()
  userScore?: number;
  @ApiProperty()
  attempts?: number;
  @ApiProperty()
  createdAt: Date;

  constructor(exercise: Exercise) {
    this.id = exercise.id;
    this.type = exercise.type;
    this.title = exercise.title;
    this.instructions = exercise.instructions;
    this.content = exercise.content;
    this.points = exercise.points;
    this.order = exercise.order;
    this.hints = exercise.hints;
    this.explanation = exercise.explanation;
    this.isActive = exercise.isActive;
    this.lesson = new LessonPreviewDto(exercise.lesson);
    this.createdAt = exercise.createdAt;

    if (exercise.userProgress && exercise.userProgress.length > 0) {
      const progress = exercise.userProgress[0];
      this.completed = progress.completed;
      this.userScore = progress.score;
      this.attempts = progress.attempts;
    }
  }
}
