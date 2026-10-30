#!/bin/sh
# Nest backup job. Runs in the backup container (deploy/backup/Dockerfile).
#
#   nest-backup run                      daily at BACKUP_TIME, and on request
#   nest-backup now                      one backup now
#   nest-backup snapshots [target]       list the snapshots of a target
#   nest-backup restore <target> <id>    restore a snapshot into the database
#
# Settings (environment):
#   RESTIC_PASSWORD   encrypts the backups; without it they cannot be read
#   BACKUP_TARGETS    space-separated name=repository pairs, e.g.
#                     "local=/backups/restic onedrive=rclone:onedrive:nest"
#   BACKUP_TIME       local time of the daily backup, HH:MM (default 03:00)
#   BACKUP_KEEP       restic forget options (default: the last 10, 14 daily,
#                     8 weekly, 12 monthly)
#   PGHOST, PGUSER, PGPASSWORD, PGDATABASE   the Nest database
#
# Every backup dumps the database once and stores the dump in each target.
# Each target gets its own row in backup_run.
set -euo pipefail

: "${RESTIC_PASSWORD:?RESTIC_PASSWORD is not set}"
export RESTIC_PASSWORD
BACKUP_TARGETS="${BACKUP_TARGETS:-local=/backups/restic}"
BACKUP_TIME="${BACKUP_TIME:-03:00}"
BACKUP_KEEP="${BACKUP_KEEP:---keep-last 10 --keep-daily 14 --keep-weekly 8 --keep-monthly 12}"
WORK=/work
DUMP="$WORK/nest.sql"
NOW_UTC="(now() at time zone 'utc')"

log() { echo "backup: $*"; }

# Runs one SQL statement and prints the result without decoration.
sql() { psql -X -q -t -A -v ON_ERROR_STOP=1 -c "$1"; }

# Quotes a value as an SQL string literal.
q() { printf "'%s'" "$(printf '%s' "$1" | sed "s/'/''/g")"; }

# The non-empty lines of a file on one line, at most 500 characters, as the
# error of a run.
error_of() { grep -v "^[[:space:]]*$" "$1" 2>/dev/null | tr "\n" " " | cut -c 1-500; }

repository_of() {
  for pair in $BACKUP_TARGETS; do
    if [ "${pair%%=*}" = "$1" ]; then
      printf '%s' "${pair#*=}"
      return 0
    fi
  done
  echo "Unknown target $1. Targets: $BACKUP_TARGETS" >&2
  return 1
}

start_run() {
  sql "INSERT INTO backup_run (\"startedAt\", status, target, \"createdAt\", \"updatedAt\")
       VALUES ($NOW_UTC, 'running', $(q "$1"), $NOW_UTC, $NOW_UTC) RETURNING id"
}

finish_run() { # id status size snapshot error
  local size="${3:-NULL}" snapshot_sql=NULL error_sql=NULL
  [ -n "${4:-}" ] && snapshot_sql=$(q "$4")
  [ -n "${5:-}" ] && error_sql=$(q "$5")
  sql "UPDATE backup_run SET status = $(q "$2"), \"finishedAt\" = $NOW_UTC,
       \"sizeBytes\" = $size, \"snapshotId\" = $snapshot_sql, error = $error_sql,
       \"updatedAt\" = $NOW_UTC WHERE id = $1" >/dev/null
}

# Stores the dump in one target and records the run.
backup_target() { # name repository size
  id=$(start_run "$1")
  export RESTIC_REPOSITORY="$2"
  if ! restic cat config >/dev/null 2>&1; then
    log "$1: creating the restic repository $2"
    if ! restic init >"$WORK/init.log" 2>&1; then
      finish_run "$id" failed "" "" "restic init: $(error_of "$WORK/init.log")"
      log "$1: failed"
      return 1
    fi
  fi
  if ! restic backup --json --tag nest --host nest "$DUMP" \
      >"$WORK/backup.json" 2>"$WORK/backup.err"; then
    finish_run "$id" failed "" "" "restic backup: $(error_of "$WORK/backup.err")"
    log "$1: failed"
    return 1
  fi
  snapshot=$(jq -r 'select(.message_type == "summary") | .snapshot_id' \
    "$WORK/backup.json" | cut -c 1-8)
  finish_run "$id" succeeded "$3" "$snapshot" ""
  log "$1: snapshot $snapshot"
  # Old snapshots are thinned out; a failure here does not fail the backup.
  # shellcheck disable=SC2086
  restic forget --tag nest --prune $BACKUP_KEEP >/dev/null 2>"$WORK/forget.err" ||
    log "$1: removing old snapshots failed: $(error_of "$WORK/forget.err")"
}

backup_now() {
  mkdir -p "$WORK"
  log "dumping the database"
  if ! pg_dump --clean --if-exists --no-password -f "$DUMP" 2>"$WORK/dump.err"; then
    for pair in $BACKUP_TARGETS; do
      id=$(start_run "${pair%%=*}")
      finish_run "$id" failed "" "" "pg_dump: $(error_of "$WORK/dump.err")"
    done
    log "database dump failed: $(error_of "$WORK/dump.err")"
    rm -f "$DUMP"
    return 1
  fi
  size=$(wc -c <"$DUMP" | tr -d ' ')
  status=0
  for pair in $BACKUP_TARGETS; do
    backup_target "${pair%%=*}" "${pair#*=}" "$size" || status=1
  done
  rm -f "$DUMP"
  return $status
}

# Seconds since the epoch of today's BACKUP_TIME (container time zone).
scheduled_today() { date -d "$(date +%Y-%m-%d) $BACKUP_TIME" +%s; }

# True when today's scheduled backup is due and has not started yet.
scheduled_backup_due() {
  at=$(scheduled_today)
  [ "$(date +%s)" -ge "$at" ] || return 1
  started=$(sql "SELECT count(*) FROM backup_run
                 WHERE \"startedAt\" >= (to_timestamp($at) at time zone 'utc')")
  [ "$started" = 0 ]
}

# True when someone pressed "Back up now"; marks the requests picked up.
backup_requested() {
  picked=$(sql "UPDATE backup_request SET \"pickedUpAt\" = $NOW_UTC,
                \"updatedAt\" = $NOW_UTC WHERE \"pickedUpAt\" IS NULL RETURNING id")
  [ -n "$picked" ]
}

run() {
  log "targets: $BACKUP_TARGETS; daily at $BACKUP_TIME ($(date +%Z))"
  until sql "SELECT 1 FROM backup_run LIMIT 1" >/dev/null 2>&1; do
    log "waiting for the database (and the Nest server's migrations)"
    sleep 10
  done
  # Runs that were cut off by a restart.
  sql "UPDATE backup_run SET status = 'failed', \"finishedAt\" = $NOW_UTC,
       error = 'interrupted', \"updatedAt\" = $NOW_UTC
       WHERE status = 'running'" >/dev/null
  while true; do
    if backup_requested 2>/dev/null; then
      log "backup requested from the admin portal"
      backup_now || true
    elif scheduled_backup_due 2>/dev/null; then
      backup_now || true
    fi
    sleep 30
  done
}

snapshots() {
  export RESTIC_REPOSITORY
  RESTIC_REPOSITORY=$(repository_of "${1:-${BACKUP_TARGETS%%=*}}")
  restic snapshots --tag nest
}

restore() {
  [ $# -eq 2 ] || { echo "Usage: nest-backup restore <target> <snapshot>" >&2; exit 2; }
  export RESTIC_REPOSITORY
  RESTIC_REPOSITORY=$(repository_of "$1")
  log "restoring snapshot $2 of $1 into database $PGDATABASE"
  restic dump "$2" "$DUMP" | psql -X -q -v ON_ERROR_STOP=1 --single-transaction >/dev/null
  log "restored. Start the Nest server again: docker compose start nest"
}

case "${1:-run}" in
  run) run ;;
  now) backup_now ;;
  snapshots) shift; snapshots "$@" ;;
  restore) shift; restore "$@" ;;
  *) echo "Unknown command $1" >&2; exit 2 ;;
esac
