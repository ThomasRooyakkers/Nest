#!/usr/bin/env bash
# Builds the web app and deploys Nest to the Raspberry Pi.
#
#   deploy/deploy.sh [user@host]
#
# Copies the repository (without secrets and build output) to ~/nest on the
# Pi and rebuilds and restarts the containers there, building the server
# image from source (docker-compose.build.yml). The Pi's deploy/.env needs
# the settings of deploy/.env.example, including COMPOSE_PROFILES=tunnel.
set -euo pipefail

HOST="${1:-thomasrooyakkers@10.1.1.215}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/id_ed25519_nest_pi}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "Building the web app"
# No SERVER_URL: the server serves the web app's config with its own address.
(cd "$ROOT/nest_flutter" && flutter build web --release)
rm -rf "$ROOT/nest_server/web/app"
mkdir -p "$ROOT/nest_server/web"
cp -R "$ROOT/nest_flutter/build/web" "$ROOT/nest_server/web/app"
rm -f "$ROOT/nest_server/web/app/assets/assets/config.json"

echo "Copying to $HOST:~/nest"
rsync -az --delete -e "ssh -i $SSH_KEY" \
  --exclude '.git/' --exclude '.dart_tool/' --exclude 'build/' \
  --exclude '.serverpod/' --exclude '.claude/' --exclude 'ios/Pods/' \
  --exclude 'config/passwords.yaml' --exclude 'deploy/.env' \
  --exclude 'deploy/backups/' \
  "$ROOT/" "$HOST:nest/"

echo "Building and starting the containers"
ssh -i "$SSH_KEY" "$HOST" \
  'cd ~/nest/deploy && docker compose -f docker-compose.yml -f docker-compose.build.yml up -d --build && docker compose ps'
