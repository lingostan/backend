export class ExerciseResultDto {
  exerciseId: number;
  correct: boolean;
  score: number;
  maxScore: number;
  feedback: string;
  correctAnswer?: any;
  completed: boolean;
  attempts: number;
  totalScore: number;

  constructor(result: ExerciseResultDto) {
    this.exerciseId = result.exerciseId;
    this.correct = result.correct;
    this.score = result.score;
    this.maxScore = result.maxScore;
    this.feedback = result.feedback;
    this.correctAnswer = result.correctAnswer;
    this.completed = result.completed;
    this.attempts = result.attempts;
    this.totalScore = result.totalScore;
  }
}
