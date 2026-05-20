import { forwardRef, Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { Mods } from './entities/mods.entity';
import { ModsService } from './mods.service';
import { ModsController } from './mods.controller';
import { UserModuleProgress } from '../progress/entities/user-module-progress.entity';
import { LessonsModule } from '../lessons/lessons.module';
import { UsersModule } from '../../users/users.module';
import { Lesson } from '../lessons/entities/lesson.entity';
import { LanguageModule } from '/language/language.module';
import { Language } from '/language/entities/language.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([Mods, UserModuleProgress, Lesson, Language]),
    forwardRef(() => LessonsModule),
    UsersModule,
  ],
  controllers: [ModsController],
  providers: [ModsService],
  exports: [ModsService],
})
export class ModsModule {}
