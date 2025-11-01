import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Mods } from './entities/mods.entity';
import { User } from '../../users/entities/user.entity';
import { UserModuleProgress } from '../progress/entities/user-module-progress.entity';

@Injectable()
export class ModsService {
  constructor(
    @InjectRepository(Mods)
    private readonly moduleRepository: Repository<Mods>,
    @InjectRepository(UserModuleProgress)
    private readonly userModuleProgressRepository: Repository<UserModuleProgress>,
  ) {}

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
}
