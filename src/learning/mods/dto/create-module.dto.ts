import {
  IsString,
  IsNumber,
  IsOptional,
  IsEnum,
  IsUrl,
  Min,
} from 'class-validator';

export class CreateModuleDto {
  @IsString()
  title: string;

  @IsString()
  description: string;

  @IsNumber()
  @Min(0)
  order: number;

  @IsEnum(['BEGINNER', 'INTERMEDIATE', 'ADVANCED'])
  difficulty: string;

  @IsOptional()
  @IsUrl()
  imageUrl?: string;

  @IsOptional()
  @IsNumber()
  @Min(0)
  estimatedDuration?: number;

  @IsNumber()
  languageId: number;
}
