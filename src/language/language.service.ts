import {
  Injectable,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Language } from './entities/language.entity';
import { CreateLanguageDto } from './dto/create-language.dto';
import { UsersService } from '../users/users.service';

@Injectable()
export class LanguageService {
  constructor(
    @InjectRepository(Language)
    private readonly languageRepository: Repository<Language>,
    private readonly usersService: UsersService,
  ) {}

  async getAllLanguages(activeOnly: boolean = true): Promise<Language[]> {
    const where = activeOnly ? { isActive: true } : {};
    return this.languageRepository.find({
      where,
      order: { name: 'ASC' },
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

    const language = this.languageRepository.create(createLanguageDto);
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
}
