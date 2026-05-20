import {
  Body,
  Controller,
  Post,
  UseGuards,
  Get,
  Res,
  HttpCode,
  Req,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { Response, Request } from 'express';
import {
  ApiBearerAuth,
  ApiBody,
  ApiOperation,
  ApiProperty,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';

class TokensResponseDto {
  @ApiProperty({
    description: 'Access token для авторизации',
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  })
  access_token: string;

  @ApiProperty({
    description: 'Refresh token для обновления access token',
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  })
  refresh_token: string;
}

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  @ApiOperation({
    summary: 'Регистрация пользователя',
    description: 'Создает нового пользователя и возвращает токены доступа',
  })
  @ApiBody({
    type: RegisterDto,
    description: 'Данные для регистрации',
  })
  @ApiResponse({
    status: 201,
    description: 'Успешная регистрация',
    type: TokensResponseDto,
  })
  async register(
    @Body() registerDto: RegisterDto,
    @Res({ passthrough: true }) res: Response,
  ) {
    const tokens = await this.authService.register(registerDto);

    res.cookie('refresh_token', tokens.refresh_token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: process.env.NODE_ENV === 'production' ? 'none' : 'strict',
      domain: undefined,
      path: '/',
      maxAge: 30 * 24 * 60 * 60 * 1000,
    });

    return {
      access_token: tokens.access_token,
      refresh_token: tokens.refresh_token,
    };
  }

  @Post('login')
  @HttpCode(200)
  @ApiOperation({
    summary: 'Вход в систему',
    description: 'Аутентификация пользователя и выдача токенов',
  })
  @ApiBody({
    type: LoginDto,
    description: 'Учетные данные для входа',
  })
  @ApiResponse({
    status: 200,
    description: 'Успешный вход',
    type: TokensResponseDto,
  })
  async login(
    @Body() loginDto: LoginDto,
    @Res({ passthrough: true }) res: Response,
  ) {
    const tokens = await this.authService.login(loginDto);

    res.cookie('refresh_token', tokens.refresh_token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: process.env.NODE_ENV === 'production' ? 'none' : 'strict',
      domain: undefined,
      path: '/',
      maxAge: 30 * 24 * 60 * 60 * 1000,
    });

    return {
      access_token: tokens.access_token,
      refresh_token: tokens.refresh_token,
    };
  }

  @Post('refresh')
  @ApiOperation({
    summary: 'Обновление токенов',
    description:
      'Обновляет access token с помощью refresh token из cookies или тела запроса',
  })
  @ApiBody({
    description: 'Refresh token (опционально, если есть в cookies)',
    schema: {
      type: 'object',
      properties: {
        refreshToken: {
          type: 'string',
          example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
          description: 'Refresh token, если не передан в cookies',
        },
      },
    },
    required: false,
  })
  @ApiResponse({
    status: 200,
    description: 'Токены успешно обновлены',
    schema: {
      example: {
        access_token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
        refresh_token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
      },
    },
  })
  async refresh(
    @Req() req: Request,
    @Body('refreshToken') refreshTokenFromBody: string | undefined,
    @Res({ passthrough: true }) res: Response,
  ) {
    let refreshToken = req.cookies?.refresh_token;

    if (!refreshToken) {
      refreshToken = refreshTokenFromBody;
    }

    if (!refreshToken) {
      throw new HttpException('Refresh token missing', HttpStatus.UNAUTHORIZED);
    }

    const tokens = await this.authService.refreshTokens(refreshToken);

    res.cookie('refresh_token', tokens.refresh_token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: process.env.NODE_ENV === 'production' ? 'none' : 'strict',
      domain: undefined,
      path: '/',
      maxAge: 30 * 24 * 60 * 60 * 1000,
    });

    return {
      access_token: tokens.access_token,
      refresh_token: tokens.refresh_token,
    };
  }

  @Post('logout')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: 'Выход из системы',
    description: 'Удаляет refresh token из cookies',
  })
  @ApiResponse({
    status: 200,
    description: 'Успешный выход',
    schema: {
      example: {
        success: true,
      },
    },
  })
  logout(@Res({ passthrough: true }) res: Response) {
    res.clearCookie('refresh_token', {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: process.env.NODE_ENV === 'production' ? 'none' : 'strict',
      domain: undefined,
      path: '/',
      maxAge: 30 * 24 * 60 * 60 * 1000,
    });
    return { success: true };
  }
}
