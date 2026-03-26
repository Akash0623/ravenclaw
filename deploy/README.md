# Ravenclaw Deployment

## Local Development

```bash
# Start locally
cd /path/to/ravenclaw
pnpm openclaw
```

## Docker Deployment

```bash
# First time
./deploy/deploy.sh --build

# Restart
./deploy/deploy.sh --restart

# Just pull and redeploy
./deploy/deploy.sh
```

## Production (VPS / Oracle Cloud)

### Initial Setup

1. Clone to `/opt/ravenclaw`:
   ```bash
   sudo git clone https://github.com/Akash0623/ravenclaw.git /opt/ravenclaw
   ```

2. Copy config:
   ```bash
   mkdir -p ~/.openclaw/workspace
   cp /opt/ravenclaw/config-templates/openclaw.json.example ~/.openclaw/openclaw.json
   cp /opt/ravenclaw/config-templates/.env.example ~/.openclaw/.env
   cp /opt/ravenclaw/config-templates/SOUL.md.example ~/.openclaw/workspace/SOUL.md
   cp /opt/ravenclaw/config-templates/MEMORY.md.example ~/.openclaw/workspace/MEMORY.md
   ```

3. Fill in API keys:
   ```bash
   nano ~/.openclaw/.env
   ```

4. Install systemd service:
   ```bash
   sudo cp /opt/ravenclaw/deploy/ravenclaw.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable ravenclaw
   sudo systemctl start ravenclaw
   ```

5. Set up log rotation:
   ```bash
   sudo cp /opt/ravenclaw/deploy/ravenclaw-logrotate.conf /etc/logrotate.d/ravenclaw
   ```

6. Set up daily backup cron:
   ```bash
   crontab -e
   # Add: 0 3 * * * /opt/ravenclaw/deploy/backup.sh
   ```

### Monitoring

```bash
# Check status
sudo systemctl status ravenclaw

# Health check
./deploy/healthcheck.sh

# View logs
docker compose logs -f

# Manual backup
./deploy/backup.sh
```

### Updates

Updates arrive as PRs from the upstream-sync workflow. After reviewing and merging:

```bash
cd /opt/ravenclaw
git pull origin main
./deploy/deploy.sh --build --restart
```
