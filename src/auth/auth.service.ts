import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { UsersService } from '../users/users.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { CreateUserDto } from '/users/dto/create-user.dto';
import { jwtConstants } from './constants';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
  ) {}

  async register(registerDto: RegisterDto) {
    const hashedPassword = await bcrypt.hash(registerDto.password, 10);
    const user = await this.usersService.create({
      ...registerDto,
      password: hashedPassword,
    });
    const payload = { email: user.email, sub: user.id };

    const accessToken = this.jwtService.sign(payload, {
      secret: jwtConstants.accessSecret,
      expiresIn: jwtConstants.accessExpiresIn,
    });

    const refreshToken = this.jwtService.sign(payload, {
      secret: jwtConstants.refreshSecret,
      expiresIn: jwtConstants.refreshExpiresIn,
    });

    return {
      access_token: accessToken,
      refresh_token: refreshToken,
    };
  }

  async login(loginDto: LoginDto) {
    const user = await this.usersService.findOneByEmail(loginDto.email);
    if (!user)
      throw new HttpException('User not found', HttpStatus.UNAUTHORIZED);

    const isMatch = await bcrypt.compare(loginDto.password, user.password);
    if (!isMatch)
      throw new HttpException('Invalid credentials', HttpStatus.UNAUTHORIZED);

    const payload = { email: user.email, sub: user.id };

    const accessToken = this.jwtService.sign(payload, {
      secret: jwtConstants.accessSecret,
      expiresIn: jwtConstants.accessExpiresIn,
    });

    const refreshToken = this.jwtService.sign(payload, {
      secret: jwtConstants.refreshSecret,
      expiresIn: jwtConstants.refreshExpiresIn,
    });

    return {
      access_token: accessToken,
      refresh_token: refreshToken,
    };
  }

  async refreshTokens(refreshToken: string) {
    try {
      const payload = this.jwtService.verify(refreshToken, {
        secret: jwtConstants.refreshSecret,
      });

      const user = await this.usersService.findOneByEmail(payload.email);
      if (!user) throw new Error();

      const newPayload = { email: payload.email, sub: payload.sub };
      const newAccessToken = this.jwtService.sign(newPayload, {
        secret: jwtConstants.accessSecret,
        expiresIn: jwtConstants.accessExpiresIn,
      });

      const newRefreshToken = this.jwtService.sign(
        { email: payload.email, sub: payload.sub },
        {
          secret: jwtConstants.refreshSecret,
          expiresIn: jwtConstants.refreshExpiresIn,
        },
      );

      return {
        access_token: newAccessToken,
        refresh_token: newRefreshToken,
      };
    } catch (err) {
      throw new HttpException(
        'Invalid or expired refresh token',
        HttpStatus.UNAUTHORIZED,
      );
    }
  }

  async profile(data: CreateUserDto) {
    const user = await this.usersService.findOneByEmail(data.email);
    if (!user) {
      return null;
    }
    return { name: user.name, email: user.email };
  }
}
