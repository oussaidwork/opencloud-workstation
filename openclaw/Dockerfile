FROM node:24-bookworm

ARG OPENCODE_VERSION=1.17.11
ARG OPENCLAW_VERSION=2026.6.10

ENV PNPM_HOME=/home/opc/.local/share/pnpm
ENV PATH=$PNPM_HOME:/usr/local/bin:$PATH
ENV HOME=/home/opc

RUN apt-get update && apt-get install -y \
    git \
    curl \
    jq \
    zsh \
    ripgrep \
    fd-find \
    fzf \
    btop \
    docker.io-client \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g pnpm@latest

RUN pnpm install -g @opencode-ai/plugin@${OPENCODE_VERSION} openclaw@${OPENCLAW_VERSION}

RUN groupadd -g 1000 opc && \
    useradd -m -u 1000 -g 1000 -s /bin/bash opc && \
    mkdir -p /home/opc/workspace/{projects,archives,templates,scripts,backups,docker,logs} && \
    mkdir -p /home/opc/.config/code-server && \
    mkdir -p /home/opc/.local/share/opencode && \
    mkdir -p /home/opc/.local/state && \
    mkdir -p /home/opc/.cache && \
    chown -R opc:opc /home/opc

COPY scripts/ /home/opc/workspace/scripts/
RUN chmod +x /home/opc/workspace/scripts/*

COPY --chown=opc:opc skills/ /home/opc/workspace/skills/

USER opc
WORKDIR /home/opc/workspace

EXPOSE 18789

CMD ["openclaw", "gateway", "--port", "18789"]
