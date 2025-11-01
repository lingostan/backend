import { Controller, Get, Param, UseGuards, Post } from '@nestjs/common';
import { LessonResponseDto } from './dto/lesson-response.dto';
import { LessonsService } from './lessons.service';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { User } from '../../users/entities/user.entity';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';

@Controller('learning/lessons')
@UseGuards(JwtAuthGuard)
export class LessonsController {
  constructor(private readonly lessonsService: LessonsService) {}

  @Get('module/:moduleId')
  async getLessonsByModule(
    @CurrentUser() user: User,
    @Param('moduleId') moduleId: number,
  ): Promise<LessonResponseDto[]> {
    const lessons = await this.lessonsService.getLessonsWithProgress(
      user.id,
      moduleId,
    );
    return lessons.map((lesson) => new LessonResponseDto(lesson));
  }

  @Get(':id')
  async getLesson(
    @CurrentUser() user: User,
    @Param('id') id: number,
  ): Promise<LessonResponseDto> {
    const lesson = await this.lessonsService.getLessonWithProgress(user.id, id);
    return new LessonResponseDto(lesson);
  }

  @Post(':id/start')
  async startLesson(
    @CurrentUser() user: User,
    @Param('id') lessonId: number,
  ): Promise<{ started: boolean }> {
    return this.lessonsService.startLesson(user.id, lessonId);
  }

  @Post(':id/complete')
  async completeLesson(
    @CurrentUser() user: User,
    @Param('id') lessonId: number,
  ): Promise<{ completed: boolean; progress: number }> {
    return this.lessonsService.completeLesson(user.id, lessonId);
  }
}
