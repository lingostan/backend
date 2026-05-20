# Lingostan Backend

API на NestJS. В Docker поднимаются **backend** и **Postgres**.

| | |
|---|---|
| Swagger | http://localhost:3000/api |
| API | префикс `/api` |

---

## Первый запуск

```bash
cp .env.example .env
```

При необходимости откройте `.env` и поменяйте пароли и порты. Для production обязательно задайте свои `JWT_ACCESS_SECRET` и `JWT_REFRESH_SECRET`.

---

## Development (для разработки)

Код в `src/` обновляется на лету — пересобирать образ после каждой правки не нужно.

```bash
docker compose up --build
```

Остановка: `Ctrl+C`, затем `docker compose down`.

| | |
|---|---|
| Makefile | `make dev` |
| Swagger | http://localhost:3000/api |
| Логи | `docker compose logs -f backend` |

**Если меняли `package.json`:**

```bash
docker compose build --no-cache backend
docker compose up
```

---

## Production (для сервера)

Приложение собирается в образ и работает в фоне. После изменений в коде нужна пересборка.

```bash
docker compose -f compose.prod.yml up -d --build
```

| | |
|---|---|
| Makefile | `make prod` |
| Остановить | `docker compose -f compose.prod.yml down` |
| Логи | `docker compose -f compose.prod.yml logs -f backend` |

Обновить версию после `git pull`:

```bash
docker compose -f compose.prod.yml up -d --build
```

---

## В чём разница

| | Development | Production |
|---|-------------|------------|
| Файл | `compose.yml` | `compose.prod.yml` |
| Запуск | `docker compose up` | `docker compose -f compose.prod.yml up -d` |
| Код | Папка `src/` с диска, hot-reload | Собран в образ (`dist/`) |
| Когда пересобирать | После смены зависимостей в `package.json` | После каждого деплоя новой версии |

Оба режима поднимают Nest и Postgres. Backend ждёт готовности базы и сам подключается к ней по имени `postgres` (это уже прописано в compose, в `.env` для Docker трогать не нужно).

---

## Переменные в `.env`

| Переменная | Зачем |
|------------|--------|
| `PORT` | Порт API на компьютере (по умолчанию `3000`) |
| `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD` | База данных |
| `POSTGRES_PUBLISH_PORT` | Порт Postgres на компьютере (для DBeaver и т.п., по умолчанию `5432`) |
| `JWT_ACCESS_SECRET`, `JWT_REFRESH_SECRET` | Секреты для токенов (в production — свои, не из примера) |

`POSTGRES_HOST` в `.env` с `localhost` — только если Nest запускаете **без** Docker. В Docker compose подставит правильные значения сам.

---

## Восстановление базы из backup

Файл `backup-28.11.sql` в корне проекта.

**Development:**

```bash
docker compose up postgres -d
docker cp ./backup-28.11.sql lingostan-postgres-dev:/tmp/backup.sql
docker exec -it lingostan-postgres-dev psql -U postgres -d lingostan -f /tmp/backup.sql
docker compose up backend
```

Имя базы `lingostan` — как в `.env` (`POSTGRES_DB`). Контейнер Postgres в production называется `lingostan-postgres`, команды те же, но с `-f compose.prod.yml`.

---

## Частые ошибки

| Проблема | Решение |
|----------|---------|
| Порт 3000 или 5432 занят | В `.env` смените `PORT` или `POSTGRES_PUBLISH_PORT` |
| Backend не видит Postgres | Не ставьте `POSTGRES_HOST=localhost` для запуска через Docker |
| После `npm install` на компьютере всё ломается в dev | `docker compose build --no-cache backend` |

---

## CI/CD: деплой на стенд (GitHub Actions)

При push в **`main`** GitHub Actions по SSH обновляет код на VPS Timeweb и перезапускает Docker.

| Шаг | Действие |
|-----|----------|
| 1 | Один раз настроить сервер: Docker, `git clone`, `.env`, `compose.prod.yml up` |
| 2 | В GitHub → Secrets: `SSH_HOST`, `SSH_USER`, `SSH_PRIVATE_KEY`, `DEPLOY_PATH` |
| 3 | `git push origin main` → деплой в Actions |

Инструкция: **[docs/DEPLOY-GITHUB-ACTIONS.md](./docs/DEPLOY-GITHUB-ACTIONS.md)**.

---

## Файлы

| Файл | Роль |
|------|------|
| `compose.yml` | Development (локально) |
| `compose.prod.yml` | Production на своём VPS |
| `docker-compose.yml` | Timeweb App Platform (опционально) |
| `.github/workflows/deploy-staging.yml` | CI/CD на стенд |
| `Dockerfile` | Сборка образа backend |
| `.env.example` | Пример настроек |

Подробности для бэкенд-разработки — в [AGENTS.md](./AGENTS.md).
