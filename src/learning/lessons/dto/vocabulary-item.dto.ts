export class VocabularyItemDto {
  word: string;
  translation: string;
  pronunciation: string;
  audioUrl: string;
  imageUrl: string;
  partOfSpeech: string;
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
