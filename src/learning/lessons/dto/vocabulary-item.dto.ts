import { ApiProperty } from '@nestjs/swagger';

export class VocabularyItemDto {
  @ApiProperty()
  word: string;
  @ApiProperty()
  translation: string;
  @ApiProperty()
  pronunciation: string;
  @ApiProperty()
  audioUrl: string;
  @ApiProperty()
  imageUrl: string;
  @ApiProperty()
  partOfSpeech: string;
  @ApiProperty()
  example: string;

  constructor(vocabularyItem: VocabularyItemDto) {
    this.word = vocabularyItem.word;
    this.translation = vocabularyItem.translation;
    this.pronunciation = vocabularyItem.pronunciation;
    this.audioUrl = vocabularyItem.audioUrl;
    this.imageUrl = vocabularyItem.imageUrl;
    this.partOfSpeech = vocabularyItem.partOfSpeech;
    this.example = vocabularyItem.example;
  }
}
