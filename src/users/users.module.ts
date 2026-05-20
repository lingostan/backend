import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { UsersController } from './users.controller';
import { UsersService } from './users.service';
import { User } from './entities/user.entity';
import { UserLanguage } from './entities/user-language.entity';
import { Language } from '../language/entities/language.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User, UserLanguage, Language])],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService],
})
export class UsersModule {}
