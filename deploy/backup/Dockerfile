# The Nest backup job: dumps the database and stores it with restic in one
# or more repositories (a local folder, an NFS share, OneDrive or any other
# rclone remote). Writes every run to the backup_run table, which the admin
# portal shows, and picks up its "Back up now" requests. See backup.sh.
FROM alpine:3.22

ARG NEST_VERSION=dev
LABEL org.opencontainers.image.title="Nest backup" \
      org.opencontainers.image.description="Backup job for a Nest server (pg_dump + restic)" \
      org.opencontainers.image.version="$NEST_VERSION" \
      org.opencontainers.image.licenses="NOASSERTION"

RUN apk add --no-cache postgresql16-client restic rclone jq tzdata ca-certificates

COPY backup.sh /usr/local/bin/nest-backup
RUN chmod +x /usr/local/bin/nest-backup

ENV RCLONE_CONFIG=/config/rclone/rclone.conf \
    RESTIC_CACHE_DIR=/backups/.cache

ENTRYPOINT ["nest-backup"]
CMD ["run"]
