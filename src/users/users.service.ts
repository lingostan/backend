import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { UserLanguage } from './entities/user-language.entity';
import { Language } from '../language/entities/language.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>,
    @InjectRepository(UserLanguage)
    private readonly userLanguageRepository: Repository<UserLanguage>,
    @InjectRepository(Language)
    private readonly languageRepository: Repository<Language>,
  ) {}

  async create(createUserDto: CreateUserDto): Promise<User> {
    const user = this.usersRepository.create(createUserDto);
    return await this.usersRepository.save(user);
  }

  async update(id: string, updateUserDto: UpdateUserDto): Promise<User> {
    const user = await this.usersRepository.findOne({ where: { id } });
    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }


    //TODO какая то шляпа, в ДТО этого нет, но по факту языки попадают сюда и ормка захлебывается 
    delete updateUserDto['languages'] 

    await this.usersRepository.update(id, updateUserDto);

    return this.usersRepository.findOne({ where: { id } });
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.usersRepository.findOne({
      where: { email },
      relations: ['languages', 'languages.language'],
    });
  }

  async findById(id: string): Promise<User | null> {
    return this.usersRepository.findOne({
      where: { id },
      relations: ['languages', 'languages.language'],
    });
  }

  async getUserLanguages(userId: string): Promise<UserLanguage[]> {
    return this.userLanguageRepository.find({
      where: { user: { id: userId } },
      relations: ['language'],
    });
  }

  async getUserWithLanguages(userId: string): Promise<User | null> {
    return this.usersRepository.findOne({
      where: { id: userId },
      relations: ['languages', 'languages.language'],
    });
  }

  async activateLanguage(
    userId: string,
    languageId: number,
  ): Promise<UserLanguage> {
    const user = await this.findById(userId);
    if (!user) {
      throw new NotFoundException('User not found');
    }

    const language = await this.languageRepository.findOne({
      where: { id: languageId },
    });

    if (!language) {
      throw new NotFoundException('Language not found');
    }

    const existingUserLanguage = await this.userLanguageRepository.findOne({
      where: { user: { id: userId }, language: { id: languageId } },
    });

    if (existingUserLanguage) {
      existingUserLanguage.isActive = true;
      return this.userLanguageRepository.save(existingUserLanguage);
    }

    const userLanguage = this.userLanguageRepository.create({
      user,
      language,
      isActive: true,
      startedAt: new Date(),
    });

    const saved = await this.userLanguageRepository.save(userLanguage);

    return this.userLanguageRepository.findOne({
      where: { id: saved.id },
      relations: ['language'],
    });
  }

  async deactivateLanguage(
    userId: string,
    languageId: number,
  ): Promise<UserLanguage> {
    const userLanguage = await this.userLanguageRepository.findOne({
      where: { user: { id: userId }, language: { id: languageId } },
    });

    if (!userLanguage) {
      throw new NotFoundException('User language not found');
    }

    userLanguage.isActive = false;
    return this.userLanguageRepository.save(userLanguage);
  }

  async updateUserLanguageProgress(
    userId: string,
    languageId: number,
    progress: number,
    points: number = 0,
  ): Promise<UserLanguage> {
    const userLanguage = await this.userLanguageRepository.findOne({
      where: { user: { id: userId }, language: { id: languageId } },
    });

    if (!userLanguage) {
      throw new NotFoundException('User language not found');
    }

    userLanguage.updateProgress(progress);
    if (points > 0) {
      userLanguage.addPoints(points);
      userLanguage.updateStreak();
    }

    return this.userLanguageRepository.save(userLanguage);
  }
}
