# OpenCloud Workstation

Mobile-first cloud development workstation — accessible via Telegram, powered by OpenClaw + OpenCode CLI.

## Architecture

```
Telegram → OpenClaw Gateway → exec tool → OpenCode CLI → workspace/git/Docker/shell
                                        → code-server (VS Code in browser)
```

## Services

| Service | Port | Purpose |
|---------|------|---------|
| OpenClaw | 18789 | AI gateway + Telegram bot |
| code-server | 8443 | VS Code in browser |
| Cloudflared | — | Optional public tunnel |

## Quick Start

### 1. Host prerequisites (one-time)

```bash
sudo dnf install -y docker docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
# log out and back in
```

### 2. Deploy

```bash
git clone https://github.com/YOUR/opencloud-workstation
cd opencloud-workstation
cp .env.example .env
# Edit .env with your API keys
docker compose up -d
```

### 3. Pair your Telegram

Message your bot and use the pairing code from the logs:

```bash
docker compose logs openclaw | grep pairing
```

## Configuration

- **Models:** edit `openclaw/config/openclaw.json`
- **Telegram pairing:** `docker compose logs openclaw | grep code`
- **Switch model in chat:** `/model opencode/mimo-v2.5-free`

## Available Commands

- `/projects` — list workspace projects with git status
- `/model <name>` — switch AI model
- Any question — answered via the active model
- Coding tasks (>5s) — delegated to OpenCode CLI via `opencode-run`

## Using Cloudflare Tunnel

```bash
docker compose --profile tunnel up -d
```

Requires `CLOUDFLARE_TUNNEL_TOKEN` in `.env`.

## Update

```bash
git pull
docker compose pull
docker compose up -d
```
