import {
  Injectable,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Not, Repository } from 'typeorm';

import { Language } from './entities/language.entity';
import {
  CreateAlphabetItemDto,
  CreateLanguageDto,
} from './dto/create-language.dto';
import { UsersService } from '../users/users.service';
import { AlphabetItem } from './entities/alphabet-item.entity';
import {
  UpdateAlphabetItemDto,
  UpdateLanguageDto,
} from './dto/update-language.dto';
import { VocabularyItemDto } from '/learning/lessons/dto/vocabulary-item.dto';

@Injectable()
export class LanguageService {
  constructor(
    @InjectRepository(Language)
    private readonly languageRepository: Repository<Language>,
    @InjectRepository(AlphabetItem)
    private readonly alphabetItemRepository: Repository<AlphabetItem>,
    private readonly usersService: UsersService,
  ) {}

  async getAllLanguages(
    activeOnly: boolean = true,
    withAlphabet: boolean = false,
  ): Promise<Language[]> {
    const where = activeOnly ? { isActive: true } : {};
    const relations = Boolean(withAlphabet) ? ['alphabet'] : [];

    return this.languageRepository.find({
      where,
      order: { name: 'ASC' },
      relations: relations,
    });
  }

  async getLanguageById(id: number): Promise<Language> {
    const language = await this.languageRepository.findOne({
      where: { id },
    });

    if (!language) {
      throw new NotFoundException(`Language with ID ${id} not found`);
    }

    return language;
  }

  async getLanguageByCode(code: string): Promise<Language> {
    const language = await this.languageRepository.findOne({
      where: { code },
    });

    if (!language) {
      throw new NotFoundException(`Language with code ${code} not found`);
    }

    return language;
  }

  async createLanguage(
    createLanguageDto: CreateLanguageDto,
  ): Promise<Language> {
    const existingLanguage = await this.languageRepository.findOne({
      where: [
        { code: createLanguageDto.code },
        { name: createLanguageDto.name },
      ],
    });

    if (existingLanguage) {
      throw new ConflictException(
        'Language with this code or name already exists',
      );
    }

    const language = this.languageRepository.create({
      ...createLanguageDto,
      alphabet: createLanguageDto.alphabet?.map((item) =>
        this.alphabetItemRepository.create(item),
      ),
    });

    return this.languageRepository.save(language);
  }

  async updateLanguage(
    id: number,
    updateLanguageDto: UpdateLanguageDto,
  ): Promise<Language> {
    const language = await this.getLanguageById(id);

    if (updateLanguageDto.code || updateLanguageDto.name) {
      const existingLanguage = await this.languageRepository.findOne({
        where: [
          { code: updateLanguageDto.code, id: Not(id) },
          { name: updateLanguageDto.name, id: Not(id) },
        ],
      });

      if (existingLanguage) {
        throw new ConflictException(
          'Language with this code or name already exists',
        );
      }
    }

    Object.assign(language, updateLanguageDto);

    if (updateLanguageDto.alphabet !== undefined) {
      await this.alphabetItemRepository.delete({
        language: { id: language.id },
      });
    }

    return this.languageRepository.save(language);
  }

  async startLanguage(userId: string, languageId: number) {
    return this.usersService.activateLanguage(userId, languageId);
  }

  async updateLanguageStats(languageId: number): Promise<void> {
    const language = await this.getLanguageById(languageId);

    // Здесь можно добавить логику подсчета модулей и упражнений
    // когда будут реализованы соответствующие модули

    await this.languageRepository.save(language);
  }

  async getAlphabet(languageId: number): Promise<AlphabetItem[]> {
    return this.alphabetItemRepository.find({
      where: { language: { id: languageId } },
      order: { order: 'ASC' },
    });
  }

  async addAlphabetItem(
    languageId: number,
    alphabetItem: CreateAlphabetItemDto,
  ): Promise<AlphabetItem> {
    const language = await this.getLanguageById(languageId);

    const item = this.alphabetItemRepository.create({
      ...alphabetItem,
      language,
    });

    return this.alphabetItemRepository.save(item);
  }

  async getVocabulary(id: number): Promise<Language> {
    const language = await this.languageRepository.findOne({
      where: { id },
    });

    return language;
  }

  async updateVocabulary(
    id: number,
    vocabularyDto: VocabularyItemDto,
  ): Promise<Language> {
    const language = await this.languageRepository.findOne({
      where: { id },
    });

    const currentVocabulary = language.vocabulary || [];

    language.vocabulary = [
      ...currentVocabulary.filter((item) => item.word !== vocabularyDto.word),
      vocabularyDto,
    ];

    return this.languageRepository.save(language);
  }

  async removeVocabularyByWord(id: number, word: string): Promise<Language> {
    const language = await this.languageRepository.findOne({
      where: { id },
    });

    const currentVocabulary = language.vocabulary || [];

    language.vocabulary = currentVocabulary.filter(
      (item) => item.word !== word,
    );

    return this.languageRepository.save(language);
  }

  async removeAlphabetItem(alphabetItemId: number): Promise<void> {
    await this.alphabetItemRepository.delete(alphabetItemId);
  }

  async deleteLanguage(languageId: number) {
    const existing = await this.languageRepository.findOne({
      where: { id: languageId },
    });

    if (existing) {
      return this.languageRepository.remove(existing);
    }
  }
}
