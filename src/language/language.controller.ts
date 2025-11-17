import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Query,
  Patch,
  Delete,
} from '@nestjs/common';
import { LanguageService } from './language.service';
import { CreateLanguageDto } from './dto/create-language.dto';
import { LanguageResponseDto } from './dto/language-response.dto';
import { UserLanguageDto } from '../users/dto/user-language.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { UpdateLanguageDto } from './dto/update-language.dto';

@Controller('languages')
export class LanguageController {
  constructor(private readonly languageService: LanguageService) {}

  @Get()
  async getAllLanguages(
    @Query('active') activeOnly?: boolean,
    @Query('withAlphabet') withAlphabet?: boolean,
  ): Promise<LanguageResponseDto[]> {
    const withAlphabetBool =
      typeof withAlphabet === 'string' && withAlphabet === 'true';

    const languages = await this.languageService.getAllLanguages(
      activeOnly,
      withAlphabetBool,
    );
    return languages.map((lang) => new LanguageResponseDto(lang));
  }

  @Get(':id')
  async getLanguage(@Param('id') id: number): Promise<LanguageResponseDto> {
    const language = await this.languageService.getLanguageById(id);
    return new LanguageResponseDto(language);
  }

  @Post()
  @UseGuards(JwtAuthGuard)
  async createLanguage(
    @Body() createLanguageDto: CreateLanguageDto,
  ): Promise<LanguageResponseDto> {
    const language =
      await this.languageService.createLanguage(createLanguageDto);
    return new LanguageResponseDto(language);
  }

  @Post(':id/start')
  @UseGuards(JwtAuthGuard)
  async startLanguage(
    @CurrentUser() user: { userId: string },
    @Param('id') id: number,
  ): Promise<UserLanguageDto> {
    const userLanguage = await this.languageService.startLanguage(
      user.userId,
      id,
    );
    return new UserLanguageDto(userLanguage);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard)
  async updateLanguage(
    @Param('id') id: number,
    @Body() updateLanguageDto: UpdateLanguageDto,
  ): Promise<LanguageResponseDto> {
    const language = await this.languageService.updateLanguage(
      id,
      updateLanguageDto,
    );
    return new LanguageResponseDto(language);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  async deleteLanguage(@Param('id') id: number) {
    return this.languageService.deleteLanguage(id);
  }
}
