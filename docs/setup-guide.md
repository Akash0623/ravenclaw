# Ravenclaw Setup Guide

This guide walks you through getting Ravenclaw running from scratch. No coding required — just copy-paste the commands.

---

## Prerequisites

You need three things installed before you start:

- **Node.js 23+** — [download from nodejs.org](https://nodejs.org)
- **pnpm 9+** — a faster alternative to npm (installed in Step 1 below)
- **Docker Desktop** — [download from docker.com](https://www.docker.com/products/docker-desktop)

To verify everything is installed, run:

```bash
node --version      # Should show v23.x.x or higher
docker --version    # Should show Docker version 24+ or higher
```

---

## Step 1: Clone and Install

```bash
git clone https://github.com/Akash0623/ravenclaw.git
cd ravenclaw
```

Install pnpm if you don't have it:

```bash
npm install -g pnpm@latest
```

Install project dependencies:

```bash
pnpm install
```

---

## Step 2: Environment Configuration

Copy the example environment file:

```bash
cp .env.example .env
```

Open `.env` in any text editor and fill in your values. The key fields are covered in the next section.

Never commit your `.env` file — it is already listed in `.gitignore`.

---

## Step 3: API Keys You Will Need

### Anthropic (for Claude models)

1. Go to [console.anthropic.com](https://console.anthropic.com)
2. Create an account and navigate to API Keys
3. Generate a new key and copy it
4. In your `.env`, set:

```
ANTHROPIC_API_KEY=sk-ant-...
```

Cost estimate: Claude Sonnet runs at roughly $3 per million input tokens and $15 per million output tokens. A typical conversational session costs under $0.01.

### OpenRouter (optional — for access to other models)

1. Go to [openrouter.ai](https://openrouter.ai)
2. Create an account and add credits
3. Generate an API key
4. In your `.env`, set:

```
OPENROUTER_API_KEY=sk-or-...
```

OpenRouter gives you access to Gemini, Llama, Mistral, and many other models through a single API. Useful if you want to route different tasks to different models.

### Telegram Bot Token (for Telegram channel)

1. Open Telegram and search for `@BotFather`
2. Send `/newbot` and follow the prompts (choose a name and username)
3. BotFather will give you a token like `7012345678:AAF...`
4. In your `.env`, set:

```
TELEGRAM_BOT_TOKEN=7012345678:AAF...
```

---

## Step 4: Channel Setup

### WhatsApp

Ravenclaw connects to WhatsApp via QR code, the same way WhatsApp Web works.

1. Start the gateway (see Step 5)
2. Watch the terminal — a QR code will appear
3. Open WhatsApp on your phone
4. Go to Settings → Linked Devices → Link a Device
5. Scan the QR code
6. The connection will stay active as long as the gateway is running

The session is saved locally so you won't need to scan again on restarts.

### Telegram

1. Make sure your `TELEGRAM_BOT_TOKEN` is set in `.env`
2. Start the gateway (see Step 5)
3. Open your bot in Telegram and send `/start`
4. The bot will respond — you're connected

To control who can use the bot, set `TELEGRAM_ALLOWED_USERS` in your `.env` to a comma-separated list of Telegram usernames.

### WebChat

WebChat is a browser-based interface built into the gateway. No extra setup needed.

Once the gateway is running, open:

```
http://localhost:18789
```

You'll see a chat interface ready to use.

---

## Step 5: First Boot

Start everything with Docker:

```bash
docker compose up
```

On the first run, Docker will pull the required images (takes a few minutes). Subsequent starts are fast.

You should see logs appear in the terminal. Look for a line like:

```
Gateway running on http://localhost:18789
```

That means it's working.

To run it in the background (so you can close the terminal):

```bash
docker compose up -d
```

To stop:

```bash
docker compose down
```

### First boot without Docker (development mode)

If you want to run without Docker for local development:

```bash
pnpm dev
```

This uses `docker-compose.override.yml` settings automatically, which sets log level to debug and maps the ports correctly.

---

## Step 6: Docker Deployment (Production)

For a server or VPS deployment, the setup is the same but you'll want to:

1. Copy the repo to your server
2. Create your `.env` on the server
3. Run `docker compose up -d`

For a clean Oracle Cloud Free Tier setup (the cheapest reliable option):

- Use an ARM-based Ampere instance (free tier, 4 OCPUs, 24 GB RAM)
- Ubuntu 22.04 LTS
- Open ports 18789 and 18790 in the security list
- Set `OPENCLAW_GATEWAY_BIND=0.0.0.0` in `.env` only if you need external access, and protect it with a strong password via `OPENCLAW_GATEWAY_PASSWORD`

Do not expose the gateway to the public internet without authentication. See the security section below.

---

## Troubleshooting

### QR code not appearing for WhatsApp

- Make sure Docker is running
- Check the logs: `docker compose logs -f`
- If the session is stuck, clear it: `rm -rf ~/.openclaw/sessions/whatsapp`
- Restart: `docker compose restart`

### Telegram bot not responding

- Confirm the bot token in `.env` is correct
- Make sure the gateway started without errors (`docker compose logs`)
- Try sending a fresh `/start` message to the bot
- Check that the bot hasn't been blocked or deleted in BotFather

### Port already in use

If port 18789 is taken by another process:

```bash
# On Mac/Linux
lsof -i :18789

# On Windows
netstat -ano | findstr :18789
```

Kill the process using that port, or change the port in `docker-compose.override.yml`.

### Models not responding / API errors

- Check that your API keys in `.env` are correct and have credits
- Anthropic keys start with `sk-ant-`
- OpenRouter keys start with `sk-or-`
- Test your Anthropic key directly:

```bash
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: YOUR_KEY_HERE" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"claude-3-5-haiku-20241022","max_tokens":10,"messages":[{"role":"user","content":"Hi"}]}'
```

If you get a JSON response with `content`, the key works.

### Docker build fails

```bash
docker compose build --no-cache
docker compose up
```

### Node version mismatch

If you see errors about Node version:

```bash
node --version
```

If it shows below v23, update Node.js from [nodejs.org](https://nodejs.org) and reinstall dependencies:

```bash
pnpm install
```

---

## Cost Estimates

These are rough figures based on typical usage patterns. Actual costs depend on how much you chat.

| Model | Input (per 1M tokens) | Output (per 1M tokens) | Daily light use est. |
|---|---|---|---|
| Claude Sonnet 4 | ~$3 | ~$15 | ~$0.05–0.20 |
| Claude Haiku 3.5 | ~$0.80 | ~$4 | ~$0.01–0.05 |
| Gemini Flash (via OpenRouter) | ~$0.075 | ~$0.30 | ~$0.005–0.02 |

For personal use with light-to-moderate conversations, expect to spend under $5/month on API costs. Heavy use with long contexts or frequent tool calls will cost more.

Tip: Use Claude Haiku or Gemini Flash for routine tasks and save Sonnet for complex reasoning. You can configure this per-channel or per-skill in Ravenclaw's config.

---

## Getting Help

- Open an issue: [github.com/Akash0623/ravenclaw/issues](https://github.com/Akash0623/ravenclaw/issues)
- Check the upstream OpenClaw docs: [docs.openclaw.ai](https://docs.openclaw.ai)
