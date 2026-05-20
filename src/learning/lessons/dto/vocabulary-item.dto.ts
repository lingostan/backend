import { ApiProperty } from '@nestjs/swagger';
import { IsOptional } from 'class-validator';

export class VocabularyItemDto {
  @ApiProperty()
  word: string;
  @IsOptional()
  @ApiProperty({ required: false })
  translation?: string;
  @ApiProperty()
  audioUrl: string;
  @ApiProperty()
  imageUrl: string;

  constructor(vocabularyItem: VocabularyItemDto) {
    this.word = vocabularyItem.word;
    this.translation = vocabularyItem.translation;
    this.audioUrl = vocabularyItem.audioUrl;
    this.imageUrl = vocabularyItem.imageUrl;
  }
}
