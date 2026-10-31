#!/usr/bin/env bash
# Builds the Nest server image, with the admin portal built in, and the
# backup image. The family app is mobile only; the server's web domain serves
# the static site in nest_server/web/site.
#
#   deploy/build-image.sh                 # local images for this machine
#   deploy/build-image.sh --push          # arm64 + amd64, pushed
#   deploy/build-image.sh --web           # only the admin portal, into nest_server/web
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

echo "Building the admin portal"
(cd "$ROOT/nest_admin" && flutter build web --release)
# Clear earlier builds (web/app held the family web app, which is gone).
rm -rf "$ROOT/nest_server/web/app" "$ROOT/nest_server/web/admin"
cp -R "$ROOT/nest_admin/build/web" "$ROOT/nest_server/web/admin"

cd "$ROOT"
if [[ "${1:-}" == "--web" ]]; then
  # The release workflow builds the images per architecture on its own.
  exit 0
elif [[ "${1:-}" == "--push" ]]; then
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
