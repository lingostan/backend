import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { Mods } from './entities/mods.entity';
import { ModsService } from './mods.service';
import { ModsController } from './mods.controller';
import { UserModuleProgress } from '../progress/entities/user-module-progress.entity';
import { LessonsModule } from '../lessons/lessons.module';
import { UsersModule } from '../../users/users.module';
import { Lesson } from '../lessons/entities/lesson.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([Mods, UserModuleProgress, Lesson]),
    LessonsModule,
    UsersModule,
  ],
  controllers: [ModsController],
  providers: [ModsService],
  exports: [ModsService],
})
export class ModsModule {}
