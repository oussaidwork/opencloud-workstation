#!/bin/bash
set -e

OPENCODE_AUTH_DIR="$HOME/.local/share/opencode"
OPENCODE_AUTH_FILE="$OPENCODE_AUTH_DIR/auth.json"

if [ -n "$OPENCODE_API_KEY" ] && [ ! -f "$OPENCODE_AUTH_FILE" ]; then
    mkdir -p "$OPENCODE_AUTH_DIR"
    cat > "$OPENCODE_AUTH_FILE" <<EOF
{
  "opencode": {
    "type": "api",
    "key": "$OPENCODE_API_KEY"
  }
}
EOF
    chmod 600 "$OPENCODE_AUTH_FILE"
fi

git config --global user.name "${GIT_USER_NAME:-DevBot}" 2>/dev/null || true
git config --global user.email "${GIT_USER_EMAIL:-devbot@opencloud.local}" 2>/dev/null || true

if [ -d "$HOME/.ssh" ]; then
    chmod 700 "$HOME/.ssh"
    chmod 600 "$HOME/.ssh/id_*" 2>/dev/null || true
    chmod 644 "$HOME/.ssh/*.pub" 2>/dev/null || true
fi

mkdir -p "$HOME/workspace"/{projects,archives,templates,scripts,backups,docker,logs}
chmod 755 "$HOME/workspace" 2>/dev/null || true

exec "$@"
