import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';

import { Mods } from './entities/mods.entity';
import { User } from '../../users/entities/user.entity';
import { UserModuleProgress } from '../progress/entities/user-module-progress.entity';
import { CreateModuleDto } from './dto/create-module.dto';
import { Language } from '/language/entities/language.entity';
import { Lesson } from '../lessons/entities/lesson.entity';
import { UpdateModuleDto } from './dto/update-module.dto';

@Injectable()
export class ModsService {
  constructor(
    @InjectRepository(Mods)
    private readonly moduleRepository: Repository<Mods>,
    @InjectRepository(UserModuleProgress)
    private readonly userModuleProgressRepository: Repository<UserModuleProgress>,
    @InjectRepository(Language)
    private readonly languageRepository: Repository<Language>,
    @InjectRepository(Lesson)
    private readonly lessonRepository: Repository<Lesson>,
  ) {}

  async getAllModules(languageId?: number) {
    const where: any = {};

    if (languageId) {
      where.language = { id: languageId };
    }

    return await this.moduleRepository.find({
      where,
      relations: ['lessons', 'language'],
    });
  }

  async createModule(createModuleDto: CreateModuleDto): Promise<any> {
    const moduleData: any = {
      ...createModuleDto,
    };

    const lang = await this.languageRepository.findOne({
      where: { id: createModuleDto.languageId },
    });

    if (createModuleDto.languageId) {
      moduleData.language = lang;
    }

    delete moduleData.languageId;
    delete moduleData.lessonIds;

    const module = this.moduleRepository.create(moduleData);
    const savedModule = (await this.moduleRepository.save(
      module,
    )) as unknown as Mods;

    if (createModuleDto.lessonIds && createModuleDto.lessonIds.length > 0) {
      await this.linkLessonsToModule(savedModule.id, createModuleDto.lessonIds);
    }

    return this.moduleRepository.findOne({
      where: { id: savedModule.id },
      relations: ['lessons'],
    });
  }

  async updateModule(
    id: number,
    updateModuleDto: UpdateModuleDto,
  ): Promise<Mods> {
    const module = await this.moduleRepository.findOne({
      where: { id },
      relations: ['language', 'lessons'],
    });

    if (!module) {
      throw new NotFoundException(`Module with ID ${id} not found`);
    }

    const updateData: any = { ...updateModuleDto };

    if (updateModuleDto.languageId) {
      const lang = await this.languageRepository.findOne({
        where: { id: updateModuleDto.languageId },
      });

      if (!lang) {
        throw new NotFoundException(
          `Language with ID ${updateModuleDto.languageId} not found`,
        );
      }

      updateData.language = lang;
    }

    if (updateModuleDto.lessonIds !== undefined) {
      await this.unlinkLessonsFromModule(id);

      if (updateModuleDto.lessonIds.length > 0) {
        await this.linkLessonsToModule(id, updateModuleDto.lessonIds);
      }
    }

    delete updateData.lessons;
    delete updateData.lessonIds;
    delete updateData.languageId;
    delete updateData.language;

    await this.moduleRepository.update(id, updateData);

    return this.moduleRepository.findOne({
      where: { id },
      relations: ['language', 'lessons'],
    });
  }

  private async unlinkLessonsFromModule(moduleId: number): Promise<void> {
    await this.moduleRepository
      .createQueryBuilder('lesson')
      .update(Lesson)
      .set({ mods: null })
      .where('modsId = :moduleId', { moduleId })
      .execute();
  }

  private async linkLessonsToModule(
    moduleId: number,
    lessonIds: number[],
  ): Promise<void> {
    const lessons = await this.lessonRepository.findBy({
      id: In(lessonIds),
    });

    for (const lesson of lessons) {
      lesson.mods = { id: moduleId } as any;
      await this.lessonRepository.save(lesson);
    }
  }

  async getModulesWithProgress(
    userId: string,
    languageId: number,
  ): Promise<Mods[]> {
    const modules = await this.moduleRepository.find({
      where: {
        language: { id: languageId },
        isActive: true,
      },
      relations: ['language', 'lessons', 'userProgress'],
      order: { order: 'ASC' },
    });

    // Добавляем прогресс для каждого модуля
    for (const module of modules) {
      const progress = await this.getUserModuleProgress(userId, module.id);
      module.userProgress = progress ? [progress] : [];
    }

    return modules;
  }

  async getModuleWithProgress(userId: string, moduleId: number): Promise<Mods> {
    const module = await this.moduleRepository.findOne({
      where: { id: moduleId },
      relations: ['language', 'lessons', 'lessons.exercises', 'userProgress'],
    });

    if (!module) {
      throw new NotFoundException(`Module with ID ${moduleId} not found`);
    }

    const progress = await this.getUserModuleProgress(userId, moduleId);
    module.userProgress = progress ? [progress] : [];

    return module;
  }

  async getUserModuleProgress(
    userId: string,
    moduleId: number,
  ): Promise<UserModuleProgress | null> {
    return this.userModuleProgressRepository.findOne({
      where: {
        user: { id: userId },
        mods: { id: moduleId },
      },
    });
  }

  async completeModule(
    userId: string,
    moduleId: number,
  ): Promise<{ completed: boolean; progress: number }> {
    const module = await this.getModuleWithProgress(userId, moduleId);
    let progress = await this.getUserModuleProgress(userId, moduleId);

    if (!progress) {
      progress = this.userModuleProgressRepository.create({
        user: { id: userId } as User,
        mods: { id: moduleId } as Mods,
        progress: 100,
        completed: true,
        completedAt: new Date(),
      });
    } else {
      progress.progress = 100;
      progress.completed = true;
      progress.completedAt = new Date();
    }

    await this.userModuleProgressRepository.save(progress);

    return {
      completed: true,
      progress: 100,
    };
  }

  async calculateModuleProgress(
    userId: string,
    moduleId: number,
  ): Promise<number> {
    const module = await this.getModuleWithProgress(userId, moduleId);
    const totalLessons = module.lessons.length;

    if (totalLessons === 0) return 0;

    // Здесь будет логика подсчета завершенных уроков
    // когда будет реализован сервис уроков

    return 0;
  }

  async deleteMod(id: number) {
    await this.lessonRepository
      .createQueryBuilder()
      .update(Lesson)
      .set({ mods: null })
      .where('modsId = :id', { id })
      .execute();

    await this.moduleRepository
      .createQueryBuilder()
      .delete()
      .from(Mods)
      .where('id = :id', { id })
      .execute();
  }
}
