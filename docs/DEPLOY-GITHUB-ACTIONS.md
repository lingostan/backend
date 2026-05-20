# CI/CD: GitHub Actions → стенд на Timeweb (VPS)

При `git push` в ветку `main` GitHub Actions подключается к серверу по SSH, подтягивает код и перезапускает Docker (`compose.prod.yml`).

Файл workflow: [`.github/workflows/deploy-staging.yml`](../.github/workflows/deploy-staging.yml)

---

## Схема

```text
git push (main) → GitHub Actions → SSH на VPS Timeweb → git pull → docker compose up -d --build
```

На сервере один раз клонируете репозиторий и создаёте `.env`. Дальше обновления только через push.

---

## 1. Подготовка сервера (один раз)

На VPS Timeweb (Ubuntu):

```bash
# Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
# перелогиньтесь

# Каталог проекта
sudo mkdir -p /var/www/lingostan-backend
sudo chown $USER:$USER /var/www/lingostan-backend
cd /var/www/lingostan-backend

# Клон (замените URL на ваш репозиторий)
git clone git@github.com:YOUR_ORG/backend.git .

cp .env.example .env
nano .env   # пароли, JWT, PORT

# Первый запуск
docker compose -f compose.prod.yml up -d --build
```

### Доступ сервера к GitHub (для `git pull`)

На сервере:

```bash
ssh-keygen -t ed25519 -C "deploy@lingostan-staging" -f ~/.ssh/github_deploy -N ""
cat ~/.ssh/github_deploy.pub
```

В GitHub: репозиторий → **Settings** → **Deploy keys** → Add deploy key (read-only достаточно).

На сервере в `~/.ssh/config`:

```
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/github_deploy
  IdentitiesOnly yes
```

Проверка: `git pull` из `/var/www/lingostan-backend`.

---

## 2. SSH-ключ для GitHub Actions

На **своём компьютере** (не на сервере):

```bash
ssh-keygen -t ed25519 -C "github-actions-deploy" -f ~/.ssh/lingostan_actions -N ""
```

- **Публичный** ключ → на сервер в `~/.ssh/authorized_keys` пользователя деплоя.
- **Приватный** ключ → в секреты GitHub (целиком, включая `-----BEGIN...`).

Проверка входа:

```bash
ssh -i ~/.ssh/lingostan_actions deploy@IP_СЕРВЕРА
```

---

## 3. Секреты в GitHub

Репозиторий → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**:

| Secret | Пример | Описание |
|--------|--------|----------|
| `SSH_HOST` | `123.45.67.89` | IP сервера Timeweb |
| `SSH_USER` | `deploy` | SSH-пользователь |
| `SSH_PRIVATE_KEY` | содержимое `lingostan_actions` | Приватный ключ |
| `SSH_PORT` | `22` | Необязательно |
| `DEPLOY_PATH` | `/var/www/lingostan-backend` | Путь к клону репозитория |

---

## 4. Ветка для автодеплоя

По умолчанию деплой с ветки **`main`**.

Другая ветка (например `develop`) — в `.github/workflows/deploy-staging.yml`:

```yaml
on:
  push:
    branches:
      - develop
```

Ручной деплой: GitHub → **Actions** → **Deploy staging** → **Run workflow**.

---

## 5. Проверка после push

1. **Actions** → последний workflow → зелёная галочка.
2. На сервере: `docker compose -f compose.prod.yml ps`
3. В браузере: `http://IP:3000/api` или ваш домен.

---

## Что делает `scripts/deploy.sh`

1. `git fetch` / `checkout` / `reset --hard` на нужную ветку  
2. `docker compose -f compose.prod.yml up -d --build`  
3. `docker image prune -f`  
4. Вывод статуса контейнеров  

Скрипт вызывается по SSH из workflow; локально на сервере: `BRANCH=main bash scripts/deploy.sh`.

---

## Частые проблемы

| Проблема | Решение |
|----------|---------|
| `Permission denied (publickey)` | Публичный ключ Actions в `authorized_keys`; верный `SSH_USER` / `SSH_HOST` |
| `git pull` failed on server | Deploy key в GitHub; `~/.ssh/config` для `github.com` |
| `ERROR: .env not found` | Создайте `.env` на сервере (не в git) |
| Workflow не запускается | Push в ветку из `on.push.branches` (по умолчанию `main`) |
| Долгая сборка / timeout | Увеличьте `timeout-minutes` в workflow или тариф VPS |

---

## Файлы compose

| Файл | Где используется |
|------|------------------|
| `compose.prod.yml` | Стенд / VPS (GitHub Actions) |
| `compose.yml` | Локальная разработка |
| `docker-compose.yml` | Только Timeweb App Platform (без volumes), если понадобится |
