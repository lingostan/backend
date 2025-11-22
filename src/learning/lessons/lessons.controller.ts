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
import {
  ApiBearerAuth,
  ApiBody,
  ApiOperation,
  ApiParam,
  ApiQuery,
  ApiResponse,
} from '@nestjs/swagger';

@ApiBearerAuth()
@Controller('learning/lessons')
@UseGuards(JwtAuthGuard)
export class LessonsController {
  constructor(private readonly lessonsService: LessonsService) {}

  @Put()
  @ApiOperation({
    summary: 'Создать урок',
  })
  @ApiBody({
    type: CreateLessonDto,
  })
  @ApiResponse({
    status: 201,
    type: LessonResponseDto,
  })
  async createLesson(@Body() lesson: CreateLessonDto) {
    return await this.lessonsService.createLesson(lesson);
  }

  @Patch(':id')
  @ApiOperation({
    summary: 'Обновить урок',
  })
  @ApiParam({
    name: 'id',
    type: Number,
    example: 1,
  })
  @ApiBody({
    type: UpdateLessonDto,
  })
  @ApiResponse({
    status: 200,
    type: LessonResponseDto,
  })
  async updateLesson(
    @Param('id') id: number,
    @Body() updateLessonDto: UpdateLessonDto,
  ) {
    return this.lessonsService.updateLesson(id, updateLessonDto);
  }

  @Get()
  @ApiOperation({
    summary: 'Получить все уроки',
  })
  @ApiQuery({
    name: 'moduleId',
    required: false,
    type: Number,
    example: 1,
  })
  @ApiResponse({
    status: 200,
    type: [LessonResponseDto],
  })
  async getAllLessons(@Query('moduleId') moduleId?: number) {
    const lessons = await this.lessonsService.getAllLessons(moduleId);

    return lessons.map((lesson) => new LessonResponseDto(lesson));
  }

  @Get('module/:moduleId')
  @ApiOperation({
    summary: 'Получить уроки по модулю с прогрессом',
  })
  @ApiParam({
    name: 'moduleId',
    type: Number,
    example: 1,
  })
  @ApiResponse({
    status: 200,
    type: [LessonResponseDto],
  })
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
  @ApiOperation({
    summary: 'Получить урок по ID',
  })
  @ApiParam({
    name: 'id',
    type: Number,
    example: 1,
  })
  @ApiResponse({
    status: 200,
    type: LessonResponseDto,
  })
  async getLesson(
    @CurrentUser() user: User,
    @Param('id') id: number,
  ): Promise<LessonResponseDto> {
    const lesson = await this.lessonsService.getLessonWithProgress(user.id, id);
    return new LessonResponseDto(lesson);
  }

  @Post(':id/start')
  @ApiOperation({
    summary: 'Начать урок',
  })
  @ApiParam({
    name: 'id',
    type: Number,
    example: 1,
  })
  @ApiResponse({
    status: 201,
    schema: {
      example: {
        started: true,
      },
    },
  })
  async startLesson(
    @CurrentUser() user: User,
    @Param('id') lessonId: number,
  ): Promise<{ started: boolean }> {
    return this.lessonsService.startLesson(user.id, lessonId);
  }

  @Post(':id/complete')
  @ApiOperation({
    summary: 'Завершить урок',
  })
  @ApiParam({
    name: 'id',
    type: Number,
    example: 1,
  })
  @ApiResponse({
    status: 201,
    schema: {
      example: {
        completed: true,
        progress: 100,
      },
    },
  })
  async completeLesson(
    @CurrentUser() user: User,
    @Param('id') lessonId: number,
  ): Promise<{ completed: boolean; progress: number }> {
    return this.lessonsService.completeLesson(user.id, lessonId);
  }

  @Delete(':id')
  @ApiOperation({
    summary: 'Удалить урок',
  })
  @ApiParam({
    name: 'id',
    type: String,
    example: '123e4567-e89b-12d3-a456-426614174000',
  })
  @ApiResponse({
    status: 200,
    schema: {
      example: {
        message: 'Lesson deleted successfully',
      },
    },
  })
  async deleteLesson(@Param('id') id: string) {
    this.lessonsService.deleteLesson(id);

    return { message: 'Lesson deleted successfully' };
  }
}
