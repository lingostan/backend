# AGENTS.md — Lingostan Backend

Контекст для AI-агентов, работающих с этим репозиторием.

## Что это за проект

**Lingostan API** — бэкенд приложения для изучения языков (аналог Duolingo). Стек: **NestJS 11**, **TypeORM**, **PostgreSQL 15**, **Passport JWT**, **Swagger**.

Основной контент в БД — **лакский язык** (`code: la`): алфавит, словарь с аудио/картинками, модули, уроки, упражнения. Медиа лежат в `public/uploads/`.

Глобальный префикс API: `/api`. Swagger UI: `http://localhost:3000/api`.

## Быстрый старт

```bash
cp .env.example .env

# Dev: Nest (watch) + Postgres
docker compose up --build
# make dev

# Prod: собранный Nest + Postgres
docker compose -f compose.prod.yml up -d --build
# make prod
```

Переменные — `.env`. Внутри Docker backend всегда ходит в Postgres по `POSTGRES_HOST=postgres` и `POSTGRES_PORT=5432` (задаётся в compose). На хост проброс порта БД — `POSTGRES_PUBLISH_PORT`.

Docker: multi-stage `Dockerfile` (`development` | `production`), `compose.yml` (dev), `compose.prod.yml` (стенд/VPS). CI/CD: push в `main` → GitHub Actions → SSH (`DEPLOY_PATH`) → `compose.prod.yml up -d --build`, см. `docs/DEPLOY-GITHUB-ACTIONS.md`.

### Восстановление БД из backup

```bash
docker cp ./backup-28.11.sql nest-postgres:/tmp/backup.sql
docker exec -it nest-postgres psql -U postgres -c "CREATE DATABASE <POSTGRES_DB>;"
docker exec -it nest-postgres psql -U postgres -d <POSTGRES_DB> -f /tmp/backup.sql
```

### Миграции TypeORM

```bash
npm run typeorm:run      # применить
npm run typeorm:revert   # откатить последнюю
npm run typeorm:migrate --name=MigrationName  # сгенерировать
```

При старте приложения `migrationsRun: true` (`src/database/typeorm.config.ts`). **`synchronize: false`** — не включать.

## Архитектура модулей

```
src/
├── app.module.ts          # корневой модуль
├── main.ts                # bootstrap, CORS, Swagger, ValidationPipe
├── auth/                  # JWT access + refresh (cookies)
├── users/                 # профиль, UserLanguage
├── language/              # языки, алфавит, vocabulary
├── learning/
│   ├── mods/              # learning_modules (модули курса)
│   ├── lessons/           # уроки
│   ├── exercises/         # упражнения + валидация ответов
│   └── progress/          # агрегированный прогресс (сервис есть, API закомментирован)
├── files/                 # upload + раздача из public/uploads
└── database/
    ├── typeorm.config.ts
    └── migrations/
```

### Доменная иерархия

```
Language → Mods (learning_modules) → Lesson → Exercise
```

Прогресс пользователя на 4 уровнях: `UserExerciseProgress`, `UserLessonProgress`, `UserModuleProgress`, `UserProgress` (+ `UserLanguage` на язык).

### Ключевые сущности

| Сущность | Таблица / файл | Заметки |
|----------|----------------|---------|
| `Language` | `language` | `alphabet` (OneToMany `AlphabetItem`), `vocabulary` JSONB |
| `Mods` | `learning_modules` | Класс `Mods`, не `Module` |
| `Lesson` | `lesson` | Связь с модулем: поле **`mods`**, не `module` |
| `Exercise` | `exercise` | `type` enum, `content` JSONB, валидаторы в entity |

## API (основные маршруты)

| Группа | Путь | Auth |
|--------|------|------|
| Auth | `POST /api/auth/register`, `login`, `refresh`, `logout` | refresh в httpOnly cookie |
| Users | `GET /api/users/profile`, `languages`; `PUT /api/users/:id` | JWT |
| Languages | `GET /api/languages`, `:id`, `alphabet`, `vocabulary` | публично / JWT на write |
| Modules | `GET/PUT/PATCH/DELETE /api/learning/modules` | JWT |
| Lessons | `GET/PUT/PATCH/DELETE /api/learning/lessons`, `:id/start`, `:id/complete` | JWT |
| Exercises | `GET/PUT/PATCH/DELETE /api/learning/exercises`, `POST :id/complete` | JWT |
| Progress | `GET /api/progress/*` | **все эндпоинты закомментированы** |
| Files | `POST /api/files/upload`, `GET /api/files/:filename` | **без JWT** |

Ядро геймплея: `POST /api/learning/exercises/:id/complete` с телом `CompleteExerciseDto` (`userAnswer`, `timeSpent`).

## Типы упражнений

Enum `ExerciseType` в `src/learning/exercises/entities/exercise.entity.ts`:

**С валидаторами:** `MULTIPLE_CHOICE`, `MATCHING`, `TRANSLATION`, `LISTENING`, `FILL_BLANK`, `REORDER`, `TRUE_FALSE`.

**Без валидаторов (complete упадёт):** `MULTIPLE_CHOICE_IMGS`, `MATCHING_AUDIO`, `SPEAKING`.

Контент и проверка ответов — в **entity** (`validateAnswer`, классы `*Validator`). При добавлении типа: enum + интерфейс content + validator + case в `getValidator()`.

## Соглашения кода

- **NestJS-модули** по фичам; DTO с `class-validator`; ответы через `*ResponseDto`.
- **Импорты:** в проекте встречаются абсолютные пути от корня (`/language/...`, `/learning/...`) — не ломать без необходимости; в `language.entity.ts` есть хрупкий import — предпочитать относительные пути при правках.
- **TypeORM relations:** у `Lesson` связь с модулем — **`mods`** (`@ManyToOne(() => Mods)`). В query builder использовать `lesson.mods`, не `lesson.module`.
- **JWT payload** (`JwtStrategy.validate`): `{ userId: string, email: string }`. Декоратор `@CurrentUser()` возвращает этот объект. В контроллерах не смешивать с `User` entity (`user.id` vs `user.userId`).
- **CRUD learning/language** защищён только `JwtAuthGuard` — **ролей admin нет**; любой залогиненный пользователь может менять контент.
- **Файлы:** `multer` → `public/uploads`, URL вида `/api/files/<filename>`. Не коммитить новые медиа без необходимости.
- **Коммиты:** только по явной просьбе пользователя. Не менять `git config`, не force-push.
- **Тесты:** `*.spec.ts` в проекте нет; Jest настроен в `package.json`.

## Известные баги и долг (не ломать при рефакторинге)

1. **`lesson.module` vs `lesson.mods`** — в `exercises.service.ts` (updateUserProgress) и `progress.service.ts` (query builder) используется неверное имя `lesson.module`. Исправлять на `lesson.mods` / `mods`.
2. **`ProgressController`** — все маршруты закомментированы; логика в `ProgressService` есть.
3. **Опечатка файла:** `src/auth/auth.contoller.ts` (не `controller`).
4. **JWT secrets** — дефолты в `src/auth/constants.ts` если нет env; в prod обязательны `JWT_ACCESS_SECRET`, `JWT_REFRESH_SECRET`.
5. **`longestStreak`** в stats — заглушка (= `currentStreak`).
6. **Prod healthcheck** — проверяет `GET /api` (Swagger); при смене префикса обновить compose.

## Что делать / чего избегать

### Делать

- Минимальный diff; следовать существующим паттернам модуля.
- При изменении схемы БД — миграция в `src/database/migrations/`, не `synchronize: true`.
- Новые эндпоинты — Swagger-декораторы (`@ApiOperation`, `@ApiBearerAuth` где нужно).
- Проверка ответов упражнений — на сервере через `Exercise.validateAnswer()`.

### Не делать

- Не включать `synchronize: true`.
- Не добавлять роли/админку без явного запроса.
- Не коммитить `.env`, секреты, лишние файлы из `public/uploads/`.
- Не расширять scope (рефакторинг всего entity exercise) без запроса.
- Не создавать пустые или тривиальные тесты «для галочки».

## Полезные команды

```bash
npm run build
npm run lint
npm run start:prod    # node dist/main
```

## Связанные файлы для типичных задач

| Задача | Файлы |
|--------|--------|
| Новый тип упражнения | `exercise.entity.ts`, DTO в `exercises/dto/` |
| Прогресс после complete | `exercises.service.ts` → `progress.service.ts`, `users.service.ts` |
| Новый язык / алфавит | `language/`, `alphabet-item.entity.ts` |
| Auth / cookies | `auth/auth.service.ts`, `auth.contoller.ts`, `jwt.strategy.ts` |
| Upload медиа | `files/files.controller.ts` |
| Схема БД | `database/migrations/`, entities в `**/entities/` |

## Контекст продукта

Приложение ориентировано на **малоресурсные / региональные языки** (сейчас — лакский). Уроки содержат vocabulary с `audioUrl` / `imageUrl`, модули по сложности (`BEGINNER` | `INTERMEDIATE` | `ADVANCED`), streak и daily goal заложены в `UserProgress`, но часть API ещё не подключена к клиенту.
