import { ApiProperty } from '@nestjs/swagger';
import { IsObject, IsNumber, IsOptional, Min } from 'class-validator';

export class CompleteExerciseDto {
  @IsObject()
  @ApiProperty()
  userAnswer: any;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @ApiProperty()
  timeSpent?: number;
}
