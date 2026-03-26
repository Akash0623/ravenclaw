# Ravenclaw Config Templates

These are template files for setting up Ravenclaw. Copy them to `~/.openclaw/` and customize before running.

## Setup Instructions

### 1. Create the openclaw directory

```bash
mkdir -p ~/.openclaw/workspace
```

### 2. Copy the config files

```bash
cp config-templates/openclaw.json.example ~/.openclaw/openclaw.json
cp config-templates/.env.example ~/.openclaw/.env
cp config-templates/SOUL.md.example ~/.openclaw/workspace/SOUL.md
cp config-templates/MEMORY.md.example ~/.openclaw/workspace/MEMORY.md
```

### 3. Fill in your secrets

Edit `~/.openclaw/.env` and replace all `CHANGE_ME` values:

- `OPENCLAW_GATEWAY_TOKEN` — generate with `openssl rand -hex 32`
- `ANTHROPIC_API_KEY` — from [console.anthropic.com](https://console.anthropic.com)
- `OPENROUTER_API_KEY` — from [openrouter.ai/keys](https://openrouter.ai/keys)
- `TELEGRAM_BOT_TOKEN` — from [@BotFather](https://t.me/BotFather) on Telegram
- WhatsApp uses QR-code login via Baileys — no token needed

### 4. Customize your identity

Edit `~/.openclaw/workspace/SOUL.md` to adjust the assistant's personality and persona.

Edit `~/.openclaw/workspace/MEMORY.md` to seed it with context about you and your projects.

## File Reference

| File | Destination | Purpose |
|------|-------------|---------|
| `openclaw.json.example` | `~/.openclaw/openclaw.json` | Main gateway + model + channel config |
| `.env.example` | `~/.openclaw/.env` | API keys and secrets |
| `SOUL.md.example` | `~/.openclaw/workspace/SOUL.md` | Agent personality and system prompt |
| `MEMORY.md.example` | `~/.openclaw/workspace/MEMORY.md` | Persistent context about you |

## Important

**Never commit real API keys.** The `~/.openclaw/.env` file should never be tracked by git. These template files use placeholder values only — they are safe to commit.
