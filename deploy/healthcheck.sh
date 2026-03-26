#!/usr/bin/env bash
set -euo pipefail

# Ravenclaw Health Check
# Usage: ./deploy/healthcheck.sh
# Exit 0 = healthy, Exit 1 = unhealthy

GATEWAY_URL="${OPENCLAW_GATEWAY_URL:-http://localhost:18789}"
TIMEOUT=10

# Check if container is running
if ! docker compose ps 2>/dev/null | grep -q "running"; then
  echo "UNHEALTHY: Container not running"
  exit 1
fi

# Check gateway responds
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time "$TIMEOUT" "$GATEWAY_URL/health" 2>/dev/null || echo "000")

if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "401" ]; then
  echo "HEALTHY: Gateway responding (HTTP $HTTP_CODE)"
  exit 0
else
  echo "UNHEALTHY: Gateway not responding (HTTP $HTTP_CODE)"
  exit 1
fi
