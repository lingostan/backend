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

@Controller('learning/modules')
@UseGuards(JwtAuthGuard)
export class ModsController {
  constructor(private readonly modulesService: ModsService) {}

  @Put()
  async createExercise(@Body() module: CreateModuleDto) {
    return await this.modulesService.createModule(module);
  }

  @Patch(':id')
  async updateModule(
    @Param('id') id: number,
    @Body() updateModuleDto: UpdateModuleDto,
  ) {
    return this.modulesService.updateModule(id, updateModuleDto);
  }

  @Get()
  async getAllModules(@Query('languageId') languageId?: number) {
    return await this.modulesService.getAllModules(languageId);
  }

  @Get('language/:languageId')
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
  async getModule(
    @CurrentUser() user: User,
    @Param('id') id: number,
  ): Promise<ModuleResponseDto> {
    const module = await this.modulesService.getModuleWithProgress(user.id, id);
    return new ModuleResponseDto(module);
  }

  @Get(':id/complete')
  async completeModule(
    @CurrentUser() user: User,
    @Param('id') moduleId: number,
  ): Promise<{ completed: boolean; progress: number }> {
    return this.modulesService.completeModule(user.id, moduleId);
  }

  @Delete(':id')
  async deleteMod(@Param('id') id: number) {
    await this.modulesService.deleteMod(id);

    return { message: 'Module deleted' };
  }
}
