#!/bin/bash
# One-time host hardening for the Docker host.
# Designed to run once on a fresh server before docker compose up.
set -euo pipefail

echo "==> Installing system packages..."
sudo dnf install -y fail2ban firewalld btop htop

echo "==> Enabling firewalld..."
sudo systemctl enable --now firewalld
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=dhcpv6-client
sudo firewall-cmd --permanent --add-port=8443/tcp   # code-server
sudo firewall-cmd --reload

echo "==> Configuring fail2ban..."
sudo tee /etc/fail2ban/jail.local > /dev/null <<'F2B'
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5

[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
F2B
sudo systemctl enable --now fail2ban

echo "==> Hardening SSH..."
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl reload sshd

echo "==> Setting up automatic updates..."
sudo dnf install -y dnf-automatic
sudo sed -i 's/^apply_updates = no/apply_updates = yes/' /etc/dnf/automatic.conf
sudo systemctl enable --now dnf-automatic

echo "==> Creating Docker volumes..."
docker volume create opencloud-workspace || true

echo ""
echo "✅ Host setup complete. Run 'docker compose up -d' to start."
