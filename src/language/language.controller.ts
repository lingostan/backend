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
import {
  ApiBearerAuth,
  ApiBody,
  ApiOperation,
  ApiParam,
  ApiQuery,
  ApiResponse,
} from '@nestjs/swagger';
import { VocabularyItemDto } from '/learning/lessons/dto/vocabulary-item.dto';
import { VocabularyItem } from '/learning/lessons/entities/lesson.entity';

@ApiBearerAuth()
@Controller('languages')
export class LanguageController {
  constructor(private readonly languageService: LanguageService) {}

  @Get()
  @ApiOperation({
    summary: 'Получить все языки',
    description: 'Возвращает список всех языков с возможностью фильтрации',
  })
  @ApiQuery({
    name: 'active',
    required: false,
    type: Boolean,
    description: 'Фильтр только активных языков',
    example: true,
  })
  @ApiQuery({
    name: 'withAlphabet',
    required: false,
    type: Boolean,
    description: 'Включить алфавит в ответ',
    example: false,
  })
  @ApiResponse({
    status: 200,
    description: 'Список языков успешно получен',
    type: [LanguageResponseDto], // Массив DTO
  })
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
  @ApiOperation({
    summary: 'Получить язык по ID',
    description: 'Возвращает информацию о конкретном языке',
  })
  @ApiParam({
    name: 'id',
    type: Number,
    example: 1,
    required: true,
  })
  @ApiResponse({
    status: 200,
    description: 'Язык успешно найден',
    type: LanguageResponseDto,
  })
  async getLanguage(@Param('id') id: number): Promise<LanguageResponseDto> {
    const language = await this.languageService.getLanguageById(id);
    return new LanguageResponseDto(language);
  }

  @Post()
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: 'Создать новый язык',
  })
  @ApiBody({
    type: CreateLanguageDto,
    description: 'Данные для создания языка',
  })
  @ApiResponse({
    status: 201,
    description: 'Язык успешно создан',
    type: LanguageResponseDto,
  })
  async createLanguage(
    @Body() createLanguageDto: CreateLanguageDto,
  ): Promise<LanguageResponseDto> {
    const language =
      await this.languageService.createLanguage(createLanguageDto);
    return new LanguageResponseDto(language);
  }

  @Get(':id/vocabulary')
  async getVocabulary(@Param('id') id: number) {
    const lang = await this.languageService.getVocabulary(id);

    return lang.vocabulary
      ? lang.vocabulary.map((item) => new VocabularyItemDto(item))
      : [];
  }

  @Post(':id/vocabulary')
  async updateVocabulary(
    @Param('id') id: number,
    @Body() vocabularyDto: VocabularyItem,
  ) {
    const vocabulary = await this.languageService.updateVocabulary(
      id,
      vocabularyDto,
    );

    return vocabulary;
  }

  @Delete(':id/vocabulary')
  async deleteVocabularyByWord(
    @Param('id') id: number,
    @Body() { word }: { word: string },
  ) {
    await this.languageService.removeVocabularyByWord(id, word);

    return { message: 'Vocabulary item deleted' };
  }

  // @Post(':id/start')
  // @UseGuards(JwtAuthGuard)
  // async startLanguage(
  //   @CurrentUser() user: { userId: string },
  //   @Param('id') id: number,
  // ): Promise<UserLanguageDto> {
  //   const userLanguage = await this.languageService.startLanguage(
  //     user.userId,
  //     id,
  //   );
  //   return new UserLanguageDto(userLanguage);
  // }

  @Patch(':id')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: 'Обновить язык',
  })
  @ApiParam({
    name: 'id',
    type: Number,
    example: 1,
    required: true,
  })
  @ApiBody({
    type: UpdateLanguageDto,
    description: 'Данные для обновления языка',
  })
  @ApiResponse({
    status: 200,
    description: 'Язык успешно обновлен',
    type: LanguageResponseDto,
  })
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
  @ApiOperation({
    summary: 'Удалить язык',
  })
  @ApiParam({
    name: 'id',
    type: Number,
    example: 1,
    required: true,
  })
  @ApiResponse({
    status: 200,
    description: 'Язык успешно удален',
    schema: {
      example: {
        message: 'Language deleted successfully',
      },
    },
  })
  async deleteLanguage(@Param('id') id: number) {
    return this.languageService.deleteLanguage(id);
  }
}
