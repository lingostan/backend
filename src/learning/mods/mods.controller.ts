import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Put,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ModuleResponseDto } from './dto/mods-response.dto';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { User } from '../../users/entities/user.entity';
import { ModsService } from './mods.service';
import { CreateModuleDto } from './dto/create-module.dto';
import { UpdateModuleDto } from './dto/update-module.dto';
import {
  ApiBearerAuth,
  ApiBody,
  ApiOperation,
  ApiParam,
  ApiQuery,
  ApiResponse,
} from '@nestjs/swagger';

@ApiBearerAuth()
@Controller('learning/modules')
@UseGuards(JwtAuthGuard)
export class ModsController {
  constructor(private readonly modulesService: ModsService) {}

  @Put()
  @ApiOperation({
    summary: 'Создать модуль',
  })
  @ApiBody({
    type: CreateModuleDto,
  })
  @ApiResponse({
    status: 201,
    type: ModuleResponseDto,
  })
  async createExercise(@Body() module: CreateModuleDto) {
    return await this.modulesService.createModule(module);
  }

  @Patch(':id')
  @ApiOperation({
    summary: 'Обновить модуль',
  })
  @ApiParam({
    name: 'id',
    type: Number,
    example: 1,
  })
  @ApiBody({
    type: UpdateModuleDto,
  })
  @ApiResponse({
    status: 200,
    type: ModuleResponseDto,
  })
  async updateModule(
    @Param('id') id: number,
    @Body() updateModuleDto: UpdateModuleDto,
  ) {
    return this.modulesService.updateModule(id, updateModuleDto);
  }

  @Get()
  @ApiOperation({
    summary: 'Получить все модули',
  })
  @ApiQuery({
    name: 'languageId',
    required: false,
    type: Number,
    example: 1,
  })
  @ApiResponse({
    status: 200,
    type: [ModuleResponseDto],
  })
  async getAllModules(@Query('languageId') languageId?: number) {
    return await this.modulesService.getAllModules(languageId);
  }

  @Get('language/:languageId')
  @ApiOperation({
    summary: 'Получить модули по языку с прогрессом',
  })
  @ApiParam({
    name: 'languageId',
    type: Number,
    example: 1,
  })
  @ApiResponse({
    status: 200,
    type: [ModuleResponseDto],
  })
  async getModulesByLanguage(
    @CurrentUser() user: User,
    @Param('languageId') languageId: number,
  ): Promise<ModuleResponseDto[]> {
    const modules = await this.modulesService.getModulesWithProgress(
      user.id,
      languageId,
    );
    return modules.map((module) => new ModuleResponseDto(module));
  }

  @Get(':id')
  @ApiOperation({
    summary: 'Получить модуль по ID',
  })
  @ApiParam({
    name: 'id',
    type: Number,
    example: 1,
  })
  @ApiResponse({
    status: 200,
    type: ModuleResponseDto,
  })
  async getModule(
    @CurrentUser() user: User,
    @Param('id') id: number,
  ): Promise<ModuleResponseDto> {
    const module = await this.modulesService.getModuleWithProgress(user.id, id);
    return new ModuleResponseDto(module);
  }

  @Get(':id/complete')
  @ApiOperation({
    summary: 'Завершить модуль',
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
        progress: 100,
      },
    },
  })
  async completeModule(
    @CurrentUser() user: User,
    @Param('id') moduleId: number,
  ): Promise<{ completed: boolean; progress: number }> {
    return this.modulesService.completeModule(user.id, moduleId);
  }

  @Delete(':id')
  @ApiOperation({
    summary: 'Удалить модуль',
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
        message: 'Module deleted',
      },
    },
  })
  async deleteMod(@Param('id') id: number) {
    await this.modulesService.deleteMod(id);

    return { message: 'Module deleted' };
  }
}
