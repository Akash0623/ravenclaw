.PHONY: dev build docker deploy restart backup health logs clean help

# Default target
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

dev: ## Start gateway locally (dev mode)
	pnpm openclaw

onboard: ## Run the setup wizard
	pnpm openclaw onboard

build: ## Build TypeScript to dist/
	pnpm build

lint: ## Run linter
	pnpm lint

test: ## Run tests
	pnpm test

docker: ## Build Docker image
	docker compose build

deploy: ## Deploy with Docker (build + start)
	./deploy/deploy.sh --build

restart: ## Restart Docker containers
	./deploy/deploy.sh --restart

stop: ## Stop Docker containers
	docker compose down

logs: ## Tail Docker logs
	docker compose logs -f

health: ## Run health check
	./deploy/healthcheck.sh

backup: ## Run backup
	./deploy/backup.sh

sync: ## Trigger upstream sync manually
	gh workflow run upstream-sync.yml

status: ## Show Docker container status
	docker compose ps

clean: ## Remove build artifacts
	rm -rf dist/ node_modules/.cache

install: ## Install dependencies
	pnpm install
