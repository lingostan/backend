import { env } from 'process';

export const jwtConstants = {
  accessSecret:
    env.JWT_ACCESS_SECRET || env.JWT_SECRET || 'access-secret',
  refreshSecret: env.JWT_REFRESH_SECRET || 'refresh-secret',
  accessExpiresIn: env.JWT_ACCESS_EXPIRES_IN || '15m',
  refreshExpiresIn: env.JWT_REFRESH_EXPIRES_IN || '7d',
};
