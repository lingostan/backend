import { Controller, Get, UseGuards, Param } from '@nestjs/common';
import { UserProgressDto } from './dto/user-progress.dto';
import { ProgressStatsDto } from './dto/progress-stats.dto';
import { StreakInfoDto } from './dto/streak-info.dto';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { User } from '../../users/entities/user.entity';
import { ProgressService } from './progress.service';
import { ApiBearerAuth } from '@nestjs/swagger';

@ApiBearerAuth()
@Controller('progress')
@UseGuards(JwtAuthGuard)
export class ProgressController {
  constructor(private readonly progressService: ProgressService) {}

  // @Get()
  // async getUserProgress(@CurrentUser() user: User): Promise<UserProgressDto[]> {
  //   const progress = await this.progressService.getUserProgress(user.id);
  //   return progress.map((p) => new UserProgressDto(p));
  // }

  // @Get('stats')
  // async getProgressStats(@CurrentUser() user: User): Promise<ProgressStatsDto> {
  //   const stats = await this.progressService.getProgressStats(user.id);
  //   return new ProgressStatsDto(stats);
  // }

  // @Get('language/:languageId')
  // async getLanguageProgress(
  //   @CurrentUser() user: User,
  //   @Param('languageId') languageId: number,
  // ): Promise<UserProgressDto> {
  //   const progress = await this.progressService.getLanguageProgress(
  //     user.id,
  //     languageId,
  //   );
  //   return new UserProgressDto(progress);
  // }

  // @Get('streak')
  // async getStreakInfo(@CurrentUser() user: User): Promise<StreakInfoDto> {
  //   const streakInfo = await this.progressService.getStreakInfo(user.id);
  //   return new StreakInfoDto(streakInfo);
  // }

  // @Get('daily')
  // async getDailyProgress(
  //   @CurrentUser() user: User,
  // ): Promise<{ goal: number; progress: number; completed: boolean }> {
  //   return this.progressService.getDailyProgress(user.id);
  // }
}
