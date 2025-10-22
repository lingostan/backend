// src/language/language.controller.ts
import {
  Controller,
  Get,
  Post,
  Body,
  UseGuards,
  Param,
  NotFoundException,
  HttpCode,
  HttpStatus,
  ForbiddenException,
} from '@nestjs/common';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { LanguageService } from './language.service';
import { StartLanguageDto } from './dto/start-language.dto';
import { CompleteModuleDto } from './dto/complete-module.dto';
import { CreateLanguageDto } from './dto/create-language.dto';

@Controller('languages')
@UseGuards(JwtAuthGuard)
export class LanguageController {
  constructor(private languageService: LanguageService) {}

  @Get()
  async getLanguages(@CurrentUser() user: { id: string }) {
    return this.languageService.getLanguagesWithProgress(user.id);
  }

  @Post('start')
  async startLanguage(
    @CurrentUser() user: { id: string },
    @Body() startDto: StartLanguageDto,
  ) {
    return this.languageService.startLearningLanguage(
      user.id,
      startDto.languageId,
    );
  }

  @Get(':languageId/modules')
  async getModules(
    @CurrentUser() user: { id: string },
    @Param('languageId') languageId: string,
  ) {
    const modules = await this.languageService.getModulesWithProgress(
      user.id,
      languageId,
    );
    if (!modules.length) {
      throw new NotFoundException('Language not found or no modules available');
    }
    return modules;
  }

  @Get(':languageId/modules/:moduleId/questions')
  async getQuestions(
    @CurrentUser() user: { id: string },
    @Param('languageId') languageId: string,
    @Param('moduleId') moduleId: string,
  ) {
    const userLang = await this.languageService.findUserLanguage(
      user.id,
      languageId,
    );
    if (!userLang) {
      throw new NotFoundException('You must start this language first');
    }

    const questions = await this.languageService.getModuleQuestions(moduleId);
    if (!questions.length) {
      throw new NotFoundException('Module not found or no questions');
    }
    return questions;
  }

  @Post(':languageId/modules/complete')
  @HttpCode(HttpStatus.OK)
  async completeModule(
    @CurrentUser() user: { id: string },
    @Param('languageId') languageId: string,
    @Body() completeDto: CompleteModuleDto,
  ) {
    return this.languageService.completeModule(
      user.id,
      languageId,
      completeDto.moduleId,
      completeDto.score,
    );
  }

  @Post()
  @UseGuards(JwtAuthGuard)
  async createLanguage(
    @CurrentUser() user: { id: string; role?: string },
    @Body() createDto: CreateLanguageDto,
  ) {
    // if (user.role !== 'admin') {
    //   throw new ForbiddenException('Only admins can create languages');
    // }

    return this.languageService.createLanguage(createDto);
  }
}
