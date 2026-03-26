#!/usr/bin/env bash
set -euo pipefail

# Ravenclaw Backup Script
# Backs up config, memory, and session state
# Usage: ./deploy/backup.sh [backup-dir]

OPENCLAW_DIR="${OPENCLAW_STATE_DIR:-$HOME/.openclaw}"
BACKUP_DIR="${1:-$HOME/ravenclaw-backups}"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/ravenclaw-backup-$TIMESTAMP.tar.gz"

echo "=== Ravenclaw Backup ==="
echo "Source: $OPENCLAW_DIR"
echo "Target: $BACKUP_FILE"

# Create backup dir
mkdir -p "$BACKUP_DIR"

# Create backup (exclude large/regeneratable files)
tar -czf "$BACKUP_FILE" \
  -C "$(dirname "$OPENCLAW_DIR")" \
  --exclude='*.log' \
  --exclude='node_modules' \
  --exclude='.cache' \
  "$(basename "$OPENCLAW_DIR")"

BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
echo "Backup complete: $BACKUP_FILE ($BACKUP_SIZE)"

# Cleanup old backups (keep last 10)
ls -t "$BACKUP_DIR"/ravenclaw-backup-*.tar.gz 2>/dev/null | tail -n +11 | xargs -r rm
REMAINING=$(ls "$BACKUP_DIR"/ravenclaw-backup-*.tar.gz 2>/dev/null | wc -l)
echo "Backups retained: $REMAINING"
