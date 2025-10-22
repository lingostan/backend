import { IsUUID, IsNumber, Min, Max } from 'class-validator';

export class CompleteModuleDto {
  @IsUUID()
  moduleId: string;

  @IsNumber()
  @Min(0)
  @Max(100)
  score: number;
}
