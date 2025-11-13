import {
  Controller,
  Get,
  Param,
  UseGuards,
  Post,
  Put,
  Body,
  Query,
  Delete,
  Patch,
} from '@nestjs/common';
import { LessonResponseDto } from './dto/lesson-response.dto';
import { LessonsService } from './lessons.service';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { User } from '../../users/entities/user.entity';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { CreateLessonDto } from './dto/create-lesson.dto';
import { UpdateLessonDto } from './dto/update-lesson.dto';

@Controller('learning/lessons')
@UseGuards(JwtAuthGuard)
export class LessonsController {
  constructor(private readonly lessonsService: LessonsService) {}

  @Put()
  async createLesson(@Body() lesson: CreateLessonDto) {
    return await this.lessonsService.createLesson(lesson);
  }

  @Patch(':id')
  async updateLesson(
    @Param('id') id: number,
    @Body() updateLessonDto: UpdateLessonDto,
  ) {
    return this.lessonsService.updateLesson(id, updateLessonDto);
  }

  @Get()
  async getAllLessons(@Query('moduleId') moduleId?: number) {
    return await this.lessonsService.getAllLessons(moduleId);
  }

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

  @Delete(':id')
  async deleteLesson(@Param('id') id: string) {
    this.lessonsService.deleteLesson(id);

    return { message: 'Lesson deleted successfully' };
  }
}
