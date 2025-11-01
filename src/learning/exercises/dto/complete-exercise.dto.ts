import { IsObject, IsNumber, IsOptional, Min } from 'class-validator';

export class CompleteExerciseDto {
  @IsObject()
  userAnswer: any;

  @IsOptional()
  @IsNumber()
  @Min(0)
  timeSpent?: number;
}
