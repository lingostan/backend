import { IsString, IsOptional } from 'class-validator';

export class AlphabetItemDto {
  @IsString()
  letter: string;

  @IsString()
  transcription: string;

  @IsString()
  @IsOptional()
  audioUrl?: string;
}
