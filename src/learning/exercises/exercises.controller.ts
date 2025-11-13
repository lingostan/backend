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

@Controller('learning/exercises')
@UseGuards(JwtAuthGuard)
export class ExercisesController {
  constructor(private readonly exercisesService: ExercisesService) {}

  @Put()
  async createExercise(@Body() exercise: CreateExerciseDto) {
    return await this.exercisesService.createExercise(exercise);
  }

  @Patch(':id')
  async updateExercise(
    @Param('id') id: number,
    @Body() updateExerciseDto: UpdateExerciseDto,
  ) {
    return this.exercisesService.updateExercise(id, updateExerciseDto);
  }

  @Get()
  async getAllExercises(
    @Query('languageId') languageId?: number,
    @Query('type') type?: ExerciseType,
  ) {
    return await this.exercisesService.getAllExercises(languageId, type);
  }

  @Get('lesson/:lessonId')
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

  @Get(':id/hint')
  async getHint(
    @CurrentUser() user: User,
    @Param('id') exerciseId: number,
  ): Promise<{ hints: string[] }> {
    const hints = await this.exercisesService.getExerciseHints(exerciseId);
    return { hints };
  }

  @Get(':id/progress')
  async getExerciseProgress(
    @CurrentUser() user: User,
    @Param('id') exerciseId: number,
  ): Promise<{ completed: boolean; score: number; attempts: number }> {
    return this.exercisesService.getExerciseProgress(user.id, exerciseId);
  }

  @Delete(':id')
  async deleteExercise(@Param('id') id: number) {
    await this.exercisesService.deleteExercise(id);

    return { message: 'Exercise deleted' };
  }
}
