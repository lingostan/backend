.PHONY: dev dev-build dev-down prod prod-build prod-down logs

# Development
dev-build:
	docker compose -f compose.yml build

dev:
	docker compose -f compose.yml up

dev-down:
	docker compose -f compose.yml down

# Production
prod-build:
	docker compose -f compose.prod.yml build

prod:
	docker compose -f compose.prod.yml up -d

prod-down:
	docker compose -f compose.prod.yml down

logs:
	docker compose -f compose.yml logs -f backend

prod-logs:
	docker compose -f compose.prod.yml logs -f backend
