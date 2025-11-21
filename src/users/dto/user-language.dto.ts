import { ApiProperty } from '@nestjs/swagger';
import { LanguageResponseDto } from '../../language/dto/language-response.dto';
import { UserLanguage } from '../entities/user-language.entity';

export class UserLanguageDto {
  @ApiProperty()
  id: number;
  @ApiProperty()
  language: LanguageResponseDto;
  @ApiProperty()
  level: number;
  @ApiProperty()
  progress: number;
  @ApiProperty()
  isActive: boolean;
  @ApiProperty()
  totalPoints: number;
  @ApiProperty()
  streak: number;
  @ApiProperty()
  startedAt: Date;
  @ApiProperty()
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
