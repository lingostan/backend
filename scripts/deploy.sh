#!/usr/bin/env bash
# Деплой на сервере (вызывается из GitHub Actions по SSH)
set -euo pipefail

DEPLOY_PATH="${DEPLOY_PATH:-$(cd "$(dirname "$0")/.." && pwd)}"
BRANCH="${BRANCH:-main}"
COMPOSE_FILE="${COMPOSE_FILE:-compose.prod.yml}"

cd "$DEPLOY_PATH"

echo "==> Deploy path: $DEPLOY_PATH"
echo "==> Branch: $BRANCH"
echo "==> Compose: $COMPOSE_FILE"

if [[ ! -f .env ]]; then
  echo "ERROR: .env not found in $DEPLOY_PATH"
  echo "Create it from .env.example before first deploy."
  exit 1
fi

echo "==> Git: fetch and checkout"
git fetch origin "$BRANCH"
git checkout "$BRANCH"
git reset --hard "origin/$BRANCH"

echo "==> Docker: build and start"
docker compose -f "$COMPOSE_FILE" up -d --build

echo "==> Docker: prune dangling images"
docker image prune -f

echo "==> Status"
docker compose -f "$COMPOSE_FILE" ps

echo "==> Done"
