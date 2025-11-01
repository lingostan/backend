import { Controller, Get, Param, UseGuards } from '@nestjs/common';
import { ModuleResponseDto } from './dto/mods-response.dto';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { User } from '../../users/entities/user.entity';
import { ModsService } from './mods.service';

@Controller('learning/modules')
@UseGuards(JwtAuthGuard)
export class ModsController {
  constructor(private readonly modulesService: ModsService) {}

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
}
