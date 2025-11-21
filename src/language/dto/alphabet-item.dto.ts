import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsOptional } from 'class-validator';

export class AlphabetItemDto {
  @IsString()
  @ApiProperty()
  letter: string;

  @IsString()
  @ApiProperty()
  transcription: string;

  @IsString()
  @IsOptional()
  @ApiProperty({ required: false })
  audioUrl?: string;
}
