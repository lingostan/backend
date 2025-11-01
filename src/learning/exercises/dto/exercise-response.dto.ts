import { Exercise, ExerciseType } from '../entities/exercise.entity';
import { LessonPreviewDto } from '../../lessons/dto/lesson-preview.dto';

export class ExerciseResponseDto {
  id: number;
  type: ExerciseType;
  title: string;
  instructions: string;
  content: any;
  points: number;
  order: number;
  hints: string[];
  explanation: string;
  isActive: boolean;
  lesson: LessonPreviewDto;
  completed?: boolean;
  userScore?: number;
  attempts?: number;
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
