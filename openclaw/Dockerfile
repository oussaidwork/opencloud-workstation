FROM node:24-bookworm

ARG OPENCODE_VERSION=1.17.11
ARG OPENCLAW_VERSION=2026.6.10

USER root
RUN apt-get update && apt-get install -y \
    git \
    curl \
    jq \
    zsh \
    ripgrep \
    fd-find \
    fzf \
    btop \
    ca-certificates \
    openssh-client \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

USER node
ENV HOME=/home/node
RUN mkdir -p /home/node/workspace/{projects,archives,templates,scripts,backups,docker,logs} && \
    mkdir -p /home/node/.local/share/opencode && \
    mkdir -p /home/node/.local/state && \
    mkdir -p /home/node/.cache

USER root
RUN npm install -g @opencode-ai/plugin@${OPENCODE_VERSION} openclaw@${OPENCLAW_VERSION}

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

COPY scripts/ /home/node/workspace/scripts/
RUN chmod +x /home/node/workspace/scripts/* && \
    chown -R node:node /home/node

COPY --chown=node:node skills/ /home/node/workspace/skills/

USER node
WORKDIR /home/node/workspace

EXPOSE 18789

ENTRYPOINT ["/entrypoint.sh"]
CMD ["openclaw", "gateway", "--port", "18789"]
