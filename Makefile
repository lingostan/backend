build-develop:
	docker-compose -f compose.yml build

develop:
	docker-compose -f compose.yml up

down:
	docker-compose -f compose.yml down