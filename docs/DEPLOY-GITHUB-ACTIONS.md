# CI/CD: GitHub Actions → стенд

При push в **`main`** workflow подключается по SSH к серверу, обновляет код в каталоге из секрета `DEPLOY_PATH` и перезапускает production-контейнеры.

Файл: [`.github/workflows/deploy-staging.yml`](../.github/workflows/deploy-staging.yml)

```text
git push main → SSH → cd $DEPLOY_PATH → git pull → docker compose -f compose.prod.yml up -d --build
```

---

## Подготовка сервера (один раз)

```bash
# Docker
curl -fsSL https://get.docker.com | sh

# Репозиторий (путь = значение DEPLOY_PATH в GitHub Secrets, например /root/backend)
git clone git@github.com:YOUR_ORG/backend.git /root/backend
cd /root/backend

cp .env.example .env
nano .env

docker compose -f compose.prod.yml up -d --build
```

Для `git pull` на сервере добавьте **Deploy key** репозитория в GitHub (Settings → Deploy keys).

---

## Секреты в GitHub

**Settings → Secrets and variables → Actions:**

| Secret | Описание |
|--------|----------|
| `SSH_HOST` | IP сервера |
| `SSH_USER` | `root` (или ваш пользователь) |
| `SSH_PRIVATE_KEY` | приватный SSH-ключ |
| `DEPLOY_PATH` | `/root/backend` — путь к клону репозитория на сервере |
| `SSH_PORT` | `22` (необязательно) |

Публичный ключ добавьте в `~/.ssh/authorized_keys` на сервере.

---

## Проверка

После `git push origin main` — вкладка **Actions** в GitHub.

На сервере:

```bash
cd $DEPLOY_PATH   # тот же путь, что в секрете
docker compose -f compose.prod.yml ps
```

API: `http://<IP>:3000/api`

Ручной деплой: **Actions → Deploy staging → Run workflow**.

---

## Частые проблемы

| Проблема | Решение |
|----------|---------|
| `Permission denied (publickey)` | Проверьте `SSH_*` секреты и `authorized_keys` |
| `git fetch` failed | Deploy key на сервере для доступа к GitHub |
| `no such file .env` | Создайте `.env` в каталоге `DEPLOY_PATH` |
| Порт занят | Смените `PORT` в `.env` |
