import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Not, IsNull } from 'typeorm';
import { UserLanguage } from '../users/entities/user-language.entity';
import { Language } from './entities/language.entity';
import { LessonModule } from '../lesson-module/entities/lesson-module.entity';
import { Question } from '../question/entities/question.entity';
import { UserModuleProgress } from '../users/entities/user-module-progress.entity';
import { CreateLanguageDto } from './dto/create-language.dto';

@Injectable()
export class LanguageService {
  constructor(
    @InjectRepository(Language)
    private languageRepository: Repository<Language>,
    @InjectRepository(LessonModule)
    private lessonModuleRepository: Repository<LessonModule>,
    @InjectRepository(Question)
    private questionRepository: Repository<Question>,
    @InjectRepository(UserLanguage)
    private userLanguageRepository: Repository<UserLanguage>,
    @InjectRepository(UserModuleProgress)
    private userModuleProgressRepository: Repository<UserModuleProgress>,
  ) {}

  async getLanguagesWithProgress(userId: string) {
    const userLanguages = await this.userLanguageRepository.find({
      where: { user: { id: userId } },
      relations: ['language'],
    });

    const allLanguages = await this.languageRepository.find();

    return allLanguages.map((lang) => {
      const userLang = userLanguages.find((ul) => ul.language.id === lang.id);
      return {
        id: lang.id,
        code: lang.code,
        name: lang.name,
        alphabet: lang.alphabet,
        status: userLang?.status || 'not_started',
        startedAt: userLang?.createdAt || null,
      };
    });
  }

  async startLearningLanguage(userId: string, code: string) {
    const existing = await this.userLanguageRepository.findOne({
      where: { user: { id: userId }, language: { code } },
      relations: ['language'],
    });

    if (existing) return existing;

    const language = await this.languageRepository.findOneBy({
      code,
    });
    if (!language) throw new NotFoundException('Language not found');

    const userLang = this.userLanguageRepository.create({
      user: { id: userId },
      language: { id: language.id },
      status: 'in_progress',
    });

    return this.userLanguageRepository.save(userLang);
  }

  async findUserLanguage(userId: string, languageId: string) {
    return this.userLanguageRepository.findOne({
      where: { user: { id: userId }, language: { id: languageId } },
      relations: ['language'],
    });
  }

  async getModulesWithProgress(userId: string, languageId: string) {
    const userLang = await this.findUserLanguage(userId, languageId);
    if (!userLang) {
      throw new NotFoundException('Language not started');
    }

    const modules = await this.lessonModuleRepository.find({
      where: { language: { id: languageId } },
      order: { order: 'ASC' },
    });

    const progresses = await this.userModuleProgressRepository.find({
      where: { userLanguage: { id: userLang.id } },
      relations: ['module'],
    });

    const progressMap = new Map<string, UserModuleProgress>();
    progresses.forEach((p) => progressMap.set(p.module.id, p));

    return modules.map((module) => {
      const progress = progressMap.get(module.id);
      return {
        id: module.id,
        title: module.title,
        order: module.order,
        completedAt: progress?.completedAt,
        score: progress?.score,
      };
    });
  }

  async getModuleQuestions(moduleId: string) {
    return this.questionRepository.find({
      where: { module: { id: moduleId } },
      select: ['id', 'type', 'questionText', 'correctAnswer', 'options'],
    });
  }

  async completeModule(
    userId: string,
    languageId: string,
    moduleId: string,
    score: number,
  ) {
    const userLang = await this.findUserLanguage(userId, languageId);
    if (!userLang) {
      throw new NotFoundException('Language not started');
    }

    const module = await this.lessonModuleRepository.findOneBy({
      id: moduleId,
    });
    if (!module || module.language.id !== languageId) {
      throw new NotFoundException('Module not found in this language');
    }

    let progress = await this.userModuleProgressRepository.findOne({
      where: { userLanguage: { id: userLang.id }, module: { id: moduleId } },
    });

    if (!progress) {
      progress = this.userModuleProgressRepository.create({
        userLanguage: userLang,
        module: { id: moduleId },
      });
    }

    progress.completedAt = new Date();
    progress.score = score;
    await this.userModuleProgressRepository.save(progress);

    // Проверяем, завершены ли все модули
    const totalModules = await this.lessonModuleRepository.count({
      where: { language: { id: languageId } },
    });
    const completedCount = await this.userModuleProgressRepository.count({
      where: { userLanguage: { id: userLang.id }, completedAt: Not(IsNull()) },
    });

    if (completedCount === totalModules && userLang.status !== 'completed') {
      userLang.status = 'completed';
      await this.userLanguageRepository.save(userLang);
    }

    return {
      moduleId: progress.module.id,
      completedAt: progress.completedAt,
      score: progress.score,
    };
  }

  async createLanguage(createDto: CreateLanguageDto) {
    const existing = await this.languageRepository.findOne({
      where: { code: createDto.code },
    });

    if (existing) {
      await this.languageRepository.update(
        { code: createDto.code },
        {
          name: createDto.name,
          alphabet: createDto.alphabet,
        },
      );

      return await this.languageRepository.findOne({
        where: { code: createDto.code },
      });
    }

    const language = this.languageRepository.create({
      code: createDto.code,
      name: createDto.name,
      alphabet: createDto.alphabet,
    });

    return await this.languageRepository.save(language);
  }
}
