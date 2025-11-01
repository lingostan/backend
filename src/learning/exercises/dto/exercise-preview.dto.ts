import { Exercise, ExerciseType } from '../entities/exercise.entity';

export class ExercisePreviewDto {
  id: number;
  type: ExerciseType;
  title: string;
  points: number;
  order: number;
  instructions: string;
  completed?: boolean;
  userScore?: number;
  attempts?: number;
  timeSpent?: number;

  constructor(exercise: Exercise) {
    this.id = exercise.id;
    this.type = exercise.type;
    this.title = exercise.title;
    this.points = exercise.points;
    this.order = exercise.order;
    this.instructions = exercise.instructions;

    if (exercise.userProgress && exercise.userProgress.length > 0) {
      const progress = exercise.userProgress[0];
      this.completed = progress.completed;
      this.userScore = progress.score;
      this.attempts = progress.attempts;
      this.timeSpent = progress.timeSpent;
    }
  }
}
