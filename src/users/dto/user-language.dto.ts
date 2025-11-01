import { LanguageResponseDto } from '../../language/dto/language-response.dto';
import { UserLanguage } from '../entities/user-language.entity';

export class UserLanguageDto {
  id: number;
  language: LanguageResponseDto;
  level: number;
  progress: number;
  isActive: boolean;
  totalPoints: number;
  streak: number;
  startedAt: Date;
  lastPracticedAt: Date;

  constructor(userLanguage: UserLanguage) {
    this.id = userLanguage.id;
    this.language = new LanguageResponseDto(userLanguage.language);
    this.level = userLanguage.level;
    this.progress = userLanguage.progress;
    this.isActive = userLanguage.isActive;
    this.totalPoints = userLanguage.totalPoints;
    this.streak = userLanguage.streak;
    this.startedAt = userLanguage.startedAt;
    this.lastPracticedAt = userLanguage.lastPracticedAt;
  }
}
