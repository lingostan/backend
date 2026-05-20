# syntax=docker/dockerfile:1
#
# Multi-stage образ backend.
# Development:  docker compose build (target: development)
# Production:   docker compose -f compose.prod.yml build (target: production)

# Базовый слой: Node.js и манифесты зависимостей
FROM node:22-alpine AS base
WORKDIR /usr/src/app
COPY package*.json ./

# --- Development: hot-reload (используется compose.yml) ---
FROM base AS development
RUN npm ci
COPY . .
EXPOSE 3000
CMD ["npm", "run", "start:dev"]

# --- Build: компиляция TypeScript → dist/ ---
FROM base AS build
RUN npm ci
COPY . .
RUN npm run build

# --- Production: только runtime, без dev-зависимостей (compose.prod.yml) ---
FROM base AS production
ENV NODE_ENV=production
RUN npm ci --omit=dev
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/public ./public
EXPOSE 3000
CMD ["npm", "run", "start:prod"]
