import {
  Controller,
  Get,
  UseGuards,
  Param,
  Post,
  Put,
  Body,
} from '@nestjs/common';
import { UsersService } from './users.service';
import { UserResponseDto } from './dto/user-response.dto';
import { UserLanguageDto } from './dto/user-language.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { User } from './entities/user.entity';
import { UpdateUserDto } from './dto/update-user.dto';

@Controller('users')
@UseGuards(JwtAuthGuard)
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('profile')
  async getProfile(
    @CurrentUser() user: { userId: string },
  ): Promise<UserResponseDto> {
    const userWithLanguages = await this.usersService.getUserWithLanguages(
      user.userId,
    );
    return new UserResponseDto(userWithLanguages);
  }

  @Put(':id')
  async update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
    return await this.usersService.update(id, updateUserDto);
  }

  @Get('languages')
  async getUserLanguages(
    @CurrentUser() user: User,
  ): Promise<UserLanguageDto[]> {
    const userWithLanguages = await this.usersService.getUserWithLanguages(
      user.id.toString(),
    );
    return userWithLanguages.languages.map((lang) => new UserLanguageDto(lang));
  }

  @Post('languages/:languageId/activate')
  async activateLanguage(
    @CurrentUser() user: User,
    @Param('languageId') languageId: number,
  ): Promise<UserLanguageDto> {
    const userLanguage = await this.usersService.activateLanguage(
      user.id,
      languageId,
    );
    return new UserLanguageDto(userLanguage);
  }

  @Post('languages/:languageId/deactivate')
  async deactivateLanguage(
    @CurrentUser() user: User,
    @Param('languageId') languageId: number,
  ): Promise<UserLanguageDto> {
    const userLanguage = await this.usersService.deactivateLanguage(
      user.id,
      languageId,
    );
    return new UserLanguageDto(userLanguage);
  }
}
