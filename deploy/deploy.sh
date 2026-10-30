#!/usr/bin/env bash
# Updates Thomas's Nest server on the Raspberry Pi to the published image.
#
#   deploy/deploy.sh [user@host]
#
# Copies deploy/docker-compose.yml to ~/nest/deploy on the Pi, dumps the
# database first, then pulls the image named in the Pi's .env (NEST_IMAGE,
# NEST_VERSION) and restarts. The Pi's .env holds the settings of
# deploy/.env.example; it is never copied or printed.
set -euo pipefail

HOST="${1:-thomasrooyakkers@10.1.1.215}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/id_ed25519_nest_pi}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SSH=(ssh -i "$SSH_KEY" "$HOST")

echo "Checking the Pi's .env"
"${SSH[@]}" 'cd ~/nest/deploy && missing=""; for k in NEST_WEB_DOMAIN NEST_API_DOMAIN SUPER_ADMIN_EMAIL NEST_IMAGE COMPOSE_PROFILES RESTIC_PASSWORD; do grep -Eq "^$k=.+" .env || missing="$missing $k"; done; [ -z "$missing" ] || { echo "Missing in .env:$missing"; exit 1; }'

echo "Dumping the database"
# Through the backup container, which owns ./backups.
"${SSH[@]}" 'cd ~/nest/deploy && docker compose exec -T backup sh -c "f=/backups/nest-pre-update-\$(date +%Y%m%d-%H%M%S).sql.gz; pg_dump -h postgres -U postgres nest | gzip > \$f.tmp && mv \$f.tmp \$f && ls -l \$f"'

echo "Copying the Compose file"
scp -i "$SSH_KEY" "$ROOT/deploy/docker-compose.yml" "$HOST:nest/deploy/docker-compose.yml"

echo "Pulling and restarting"
"${SSH[@]}" 'cd ~/nest/deploy && docker compose pull && docker compose up -d --remove-orphans && docker compose ps'
