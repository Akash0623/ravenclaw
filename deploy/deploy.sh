#!/usr/bin/env bash
set -euo pipefail

# Ravenclaw Production Deploy Script
# Usage: ./deploy/deploy.sh [--build] [--restart]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
OPENCLAW_DIR="${OPENCLAW_STATE_DIR:-$HOME/.openclaw}"

echo "=== Ravenclaw Deploy ==="
echo "Project: $PROJECT_DIR"
echo "Config:  $OPENCLAW_DIR"
echo ""

# Parse args
BUILD=false
RESTART=false
for arg in "$@"; do
  case $arg in
    --build) BUILD=true ;;
    --restart) RESTART=true ;;
    *) echo "Unknown arg: $arg"; exit 1 ;;
  esac
done

# Pre-flight checks
echo "[1/5] Pre-flight checks..."
command -v docker >/dev/null 2>&1 || { echo "ERROR: docker not found"; exit 1; }
command -v docker compose >/dev/null 2>&1 || { echo "ERROR: docker compose not found"; exit 1; }

if [ ! -f "$OPENCLAW_DIR/.env" ]; then
  echo "ERROR: $OPENCLAW_DIR/.env not found. Copy from config-templates/.env.example"
  exit 1
fi

if grep -q "CHANGE_ME" "$OPENCLAW_DIR/.env"; then
  echo "ERROR: $OPENCLAW_DIR/.env still has CHANGE_ME placeholders. Fill in your API keys."
  exit 1
fi

echo "  Docker: $(docker --version | cut -d' ' -f3)"
echo "  Config: OK"
echo ""

# Pull latest
echo "[2/5] Pulling latest code..."
cd "$PROJECT_DIR"
git pull origin main

# Build if requested
if [ "$BUILD" = true ]; then
  echo "[3/5] Building Docker image..."
  docker compose build
else
  echo "[3/5] Skipping build (use --build to rebuild)"
fi

# Deploy
echo "[4/5] Deploying..."
if [ "$RESTART" = true ]; then
  docker compose down
fi
docker compose up -d

# Health check
echo "[5/5] Health check..."
sleep 5
if docker compose ps | grep -q "running"; then
  echo ""
  echo "=== Ravenclaw is running ==="
  docker compose ps
  echo ""
  echo "Gateway: http://localhost:18789"
else
  echo "ERROR: Container not running. Check logs:"
  echo "  docker compose logs -f"
  exit 1
fi
