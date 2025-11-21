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
import {
  ApiBearerAuth,
  ApiBody,
  ApiOperation,
  ApiParam,
  ApiResponse,
} from '@nestjs/swagger';

@ApiBearerAuth()
@Controller('users')
@UseGuards(JwtAuthGuard)
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('profile')
  @ApiOperation({
    summary: 'Получить профиль пользователя',
  })
  @ApiResponse({
    status: 200,
    description: 'Профиль пользователя',
    type: UserResponseDto,
  })
  async getProfile(
    @CurrentUser() user: { userId: string },
  ): Promise<UserResponseDto> {
    const userWithLanguages = await this.usersService.getUserWithLanguages(
      user.userId,
    );
    return new UserResponseDto(userWithLanguages);
  }

  @Put(':id')
  @ApiOperation({
    summary: 'Обновить данные пользователя',
  })
  @ApiParam({
    name: 'id',
    type: String,
  })
  @ApiBody({
    type: UpdateUserDto,
    description: 'Данные для обновления',
  })
  @ApiResponse({
    status: 200,
    description: 'Пользователь успешно обновлен',
    type: UserResponseDto,
  })
  async update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
    return await this.usersService.update(id, updateUserDto);
  }

  @Get('languages')
  @ApiOperation({
    summary: 'Получить языки пользователя',
  })
  @ApiResponse({
    status: 200,
    type: [UserLanguageDto],
  })
  async getUserLanguages(
    @CurrentUser() user: User,
  ): Promise<UserLanguageDto[]> {
    const userWithLanguages = await this.usersService.getUserWithLanguages(
      user.id.toString(),
    );
    return userWithLanguages.languages.map((lang) => new UserLanguageDto(lang));
  }

  // @Post('languages/:languageId/activate')
  // async activateLanguage(
  //   @CurrentUser() user: User,
  //   @Param('languageId') languageId: number,
  // ): Promise<UserLanguageDto> {
  //   const userLanguage = await this.usersService.activateLanguage(
  //     user.id,
  //     languageId,
  //   );
  //   return new UserLanguageDto(userLanguage);
  // }

  // @Post('languages/:languageId/deactivate')
  // async deactivateLanguage(
  //   @CurrentUser() user: User,
  //   @Param('languageId') languageId: number,
  // ): Promise<UserLanguageDto> {
  //   const userLanguage = await this.usersService.deactivateLanguage(
  //     user.id,
  //     languageId,
  //   );
  //   return new UserLanguageDto(userLanguage);
  // }
}
