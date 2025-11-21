import {
  Controller,
  Get,
  Param,
  Post,
  Body,
  UseGuards,
  Put,
  Query,
  Delete,
  Patch,
} from '@nestjs/common';
import { ExerciseResponseDto } from './dto/exercise-response.dto';
import { CompleteExerciseDto } from './dto/complete-exercise.dto';
import { ExerciseResultDto } from './dto/exercise-result.dto';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { User } from '../../users/entities/user.entity';
import { ExercisesService } from './exercises.service';
import { CreateExerciseDto } from './dto/create-exercise.dto';
import { ExerciseType } from './entities/exercise.entity';
import { UpdateExerciseDto } from './dto/update-exercise.dto';
import {
  ApiBearerAuth,
  ApiBody,
  ApiOperation,
  ApiParam,
  ApiQuery,
  ApiResponse,
} from '@nestjs/swagger';

@ApiBearerAuth()
@Controller('learning/exercises')
@UseGuards(JwtAuthGuard)
export class ExercisesController {
  constructor(private readonly exercisesService: ExercisesService) {}

  @Put()
  @ApiOperation({
    summary: 'Создать упражнение',
  })
  @ApiBody({
    type: CreateExerciseDto,
  })
  @ApiResponse({
    status: 201,
    type: ExerciseResponseDto,
  })
  async createExercise(@Body() exercise: CreateExerciseDto) {
    return await this.exercisesService.createExercise(exercise);
  }

  @Patch(':id')
  @ApiOperation({
    summary: 'Обновить упражнение',
  })
  @ApiParam({
    name: 'id',
    type: Number,
    example: 1,
  })
  @ApiBody({
    type: UpdateExerciseDto,
  })
  @ApiResponse({
    status: 200,
    type: ExerciseResponseDto,
  })
  async updateExercise(
    @Param('id') id: number,
    @Body() updateExerciseDto: UpdateExerciseDto,
  ) {
    return this.exercisesService.updateExercise(id, updateExerciseDto);
  }

  @Get()
  @ApiOperation({
    summary: 'Получить все упражнения',
  })
  @ApiQuery({
    name: 'languageId',
    required: false,
    type: Number,
    example: 1,
  })
  @ApiQuery({
    name: 'type',
    required: false,
    enum: ExerciseType,
  })
  @ApiResponse({
    status: 200,
    type: [ExerciseResponseDto],
  })
  async getAllExercises(
    @Query('languageId') languageId?: number,
    @Query('type') type?: ExerciseType,
  ) {
    return await this.exercisesService.getAllExercises(languageId, type);
  }

  @Get('lesson/:lessonId')
  @ApiOperation({
    summary: 'Получить упражнения по уроку с прогрессом',
  })
  @ApiParam({
    name: 'lessonId',
    type: Number,
    example: 1,
  })
  @ApiResponse({
    status: 200,
    type: [ExerciseResponseDto],
  })
  async getExercisesByLesson(
    @CurrentUser() user: User,
    @Param('lessonId') lessonId: number,
  ): Promise<ExerciseResponseDto[]> {
    const exercises = await this.exercisesService.getExercisesWithProgress(
      user.id,
      lessonId,
    );
    return exercises.map((exercise) => new ExerciseResponseDto(exercise));
  }

  @Get(':id')
  @ApiOperation({
    summary: 'Получить упражнение по ID',
  })
  @ApiParam({
    name: 'id',
    type: Number,
    example: 1,
  })
  @ApiResponse({
    status: 200,
    type: ExerciseResponseDto,
  })
  async getExercise(
    @CurrentUser() user: User,
    @Param('id') id: number,
  ): Promise<ExerciseResponseDto> {
    const exercise = await this.exercisesService.getExerciseWithProgress(
      user.id,
      id,
    );
    return new ExerciseResponseDto(exercise);
  }

  @Post(':id/complete')
  @ApiOperation({
    summary: 'Завершить упражнение',
  })
  @ApiParam({
    name: 'id',
    type: Number,
    example: 1,
  })
  @ApiBody({
    type: CompleteExerciseDto,
  })
  @ApiResponse({
    status: 201,
    type: ExerciseResultDto,
  })
  async completeExercise(
    @CurrentUser() user: User,
    @Param('id') exerciseId: number,
    @Body() completeExerciseDto: CompleteExerciseDto,
  ): Promise<ExerciseResultDto> {
    const result = await this.exercisesService.completeExercise(
      user.id,
      exerciseId,
      completeExerciseDto,
    );
    return new ExerciseResultDto(result);
  }

  @Get(':id/progress')
  @ApiOperation({
    summary: 'Получить прогресс упражнения',
  })
  @ApiParam({
    name: 'id',
    type: Number,
    example: 1,
  })
  @ApiResponse({
    status: 200,
    schema: {
      example: {
        completed: true,
        score: 85,
        attempts: 3,
      },
    },
  })
  async getExerciseProgress(
    @CurrentUser() user: User,
    @Param('id') exerciseId: number,
  ): Promise<{ completed: boolean; score: number; attempts: number }> {
    return this.exercisesService.getExerciseProgress(user.id, exerciseId);
  }

  @Delete(':id')
  @ApiOperation({
    summary: 'Удалить упражнение',
  })
  @ApiParam({
    name: 'id',
    type: Number,
    example: 1,
  })
  @ApiResponse({
    status: 200,
    schema: {
      example: {
        message: 'Exercise deleted',
      },
    },
  })
  async deleteExercise(@Param('id') id: number) {
    await this.exercisesService.deleteExercise(id);

    return { message: 'Exercise deleted' };
  }
}
