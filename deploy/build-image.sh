#!/usr/bin/env bash
# Builds the Nest server image, with the web app and the admin portal built
# in, and the backup image.
#
#   deploy/build-image.sh                 # local images for this machine
#   deploy/build-image.sh --push          # arm64 + amd64, pushed
#
# IMAGE (default ghcr.io/thomasrooyakkers/nest-server), BACKUP_IMAGE (default
# ghcr.io/thomasrooyakkers/nest-backup) and VERSION (default: the server
# version in nest_server/lib/src/endpoints/health_endpoint.dart) name the
# images. Releases are pushed by .github/workflows/server-image.yml.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
IMAGE="${IMAGE:-ghcr.io/thomasrooyakkers/nest-server}"
BACKUP_IMAGE="${BACKUP_IMAGE:-ghcr.io/thomasrooyakkers/nest-backup}"
VERSION="${VERSION:-$(sed -n "s/^const nestServerVersion = '\(.*\)';/\1/p" \
  "$ROOT/nest_server/lib/src/endpoints/health_endpoint.dart")}"

echo "Building the web app"
# No SERVER_URL: the server serves the web app's config with its own address.
(cd "$ROOT/nest_flutter" && flutter build web --release)
rm -rf "$ROOT/nest_server/web/app"
mkdir -p "$ROOT/nest_server/web"
cp -R "$ROOT/nest_flutter/build/web" "$ROOT/nest_server/web/app"
# The server generates this file (see WebAppConfigRoute).
rm -f "$ROOT/nest_server/web/app/assets/assets/config.json"

echo "Building the admin portal"
(cd "$ROOT/nest_admin" && flutter build web --release)
rm -rf "$ROOT/nest_server/web/admin"
cp -R "$ROOT/nest_admin/build/web" "$ROOT/nest_server/web/admin"

cd "$ROOT"
if [[ "${1:-}" == "--push" ]]; then
  echo "Building and pushing $IMAGE:$VERSION for arm64 and amd64"
  docker buildx build --platform linux/arm64,linux/amd64 \
    -f nest_server/Dockerfile --build-arg NEST_VERSION="$VERSION" \
    -t "$IMAGE:$VERSION" -t "$IMAGE:latest" --push .
  echo "Building and pushing $BACKUP_IMAGE:$VERSION for arm64 and amd64"
  docker buildx build --platform linux/arm64,linux/amd64 \
    --build-arg NEST_VERSION="$VERSION" \
    -t "$BACKUP_IMAGE:$VERSION" -t "$BACKUP_IMAGE:latest" --push deploy/backup
else
  echo "Building $IMAGE:$VERSION for this machine"
  docker build -f nest_server/Dockerfile --build-arg NEST_VERSION="$VERSION" \
    -t "$IMAGE:$VERSION" -t "$IMAGE:latest" .
  echo "Building $BACKUP_IMAGE:$VERSION for this machine"
  docker build --build-arg NEST_VERSION="$VERSION" \
    -t "$BACKUP_IMAGE:$VERSION" -t "$BACKUP_IMAGE:latest" deploy/backup
fi
