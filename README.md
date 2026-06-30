# OpenCloud Workstation

Mobile-first cloud development workstation accessible via Telegram,
powered by OpenClaw + OpenCode CLI.

**One command to deploy:**

```bash
git clone https://github.com/oussaidwork/opencloud-workstation
cd opencloud-workstation
cp .env.example .env   # ← fill in your API keys
docker compose up -d
```

## What you get

| Service | Port | Purpose |
|---------|------|---------|
| OpenClaw | 18789 | AI gateway + Telegram bot |
| code-server | 8443 | VS Code in browser |
| Cloudflared | — | Optional public tunnel |

## Prerequisites

A Linux server with Docker + Compose installed:

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
# log out and back in
```

## First-time setup

### 1. Get API keys

| Key | Where to get | Required |
|-----|-------------|----------|
| `TELEGRAM_BOT_TOKEN` | [@BotFather](https://t.me/BotFather) | Yes |
| `OPENCODE_API_KEY` | [opencode.ai/auth](https://opencode.ai/auth) | Yes |
| `CODE_SERVER_PASSWORD` | pick one | Yes |
| `GEMINI_API_KEY` | [aistudio.google.com](https://aistudio.google.com/apikey) | Optional |
| `OPENROUTER_API_KEY` | [openrouter.ai/keys](https://openrouter.ai/keys) | Optional |

### 2. Deploy

```bash
cp .env.example .env
nano .env        # paste your keys
docker compose up -d
```

### 3. Pair Telegram

Check the logs for a pairing code:

```bash
docker compose logs openclaw | grep -i "code\|pair"
```

Send the code to your bot on Telegram to approve the device.

### 4. Open VS Code

Visit `http://your-server:8443` — password is `CODE_SERVER_PASSWORD`.

## Usage

| Command | What it does |
|---------|-------------|
| `/projects` | List workspace projects with git status |
| `/model <name>` | Switch AI model (see available models below) |
| Any message | Answered via the active model |
| Coding tasks | Auto-delegated to OpenCode CLI |

### Free models (included)

- `opencode/deepseek-v4-flash-free`
- `opencode/mimo-v2.5-free`
- `opencode/nemotron-3-ultra-free`
- `opencode/north-mini-code-free`

Switch in Telegram: `/model opencode/mimo-v2.5-free`

## Private git repos

The compose file forwards your local SSH agent automatically.
If you don't run an SSH agent, mount your keys directly:

```yaml
volumes:
  - ~/.ssh:/home/node/.ssh:ro
```

## Cloudflare Tunnel

```bash
docker compose --profile tunnel up -d
```

Requires `CLOUDFLARE_TUNNEL_TOKEN` in `.env`.

## Update

```bash
git pull
docker compose down
docker compose build --no-cache openclaw
docker compose up -d
```

## Architecture

```
Telegram → OpenClaw → exec → OpenCode CLI → git / Docker / shell
                   → code-server (VS Code in browser)
```

All state lives in Docker volumes (`openclaw-config`, `workspace`).
Destroy and recreate containers without losing data.
