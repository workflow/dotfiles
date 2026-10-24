# One-off: the opencode 1.x channel build kept its sessions in
# opencode-stable.db, but 2.x opens opencode.db and never sees them. Hand the
# 1.x database to 2.x, which migrates it in place when its server starts.
# Run with every opencode TUI closed; originals stay in pre-v2-backup/.

data=${XDG_DATA_HOME:-$HOME/.local/share}/opencode
legacy=$data/opencode-stable.db
current=$data/opencode.db
backup=$data/pre-v2-backup
sync_state=${XDG_STATE_HOME:-$HOME/.local/state}/opencode-sync/state.json

main() {
  preflight
  stop_opencode
  back_up
  promote_legacy_database
  migrate
  report
}

preflight() {
  [ -f "$legacy" ] || die "no $legacy, nothing to recover"
  [ ! -e "$backup" ] || die "$backup exists, recovery already ran"
}

stop_opencode() {
  systemctl --user stop opencode-session-sync.timer opencode-session-sync.service
  # Fails when no server runs; the process check below catches a real failure.
  opencode service stop || true
  if pgrep -f '/\.opencode-wrapped' >/dev/null; then
    systemctl --user start opencode-session-sync.timer
    die "quit every running opencode session first"
  fi
}

back_up() {
  mkdir "$backup"
  mv "$current" "$current"-wal "$current"-shm "$backup"/ 2>/dev/null || true
  cp -a "$legacy" "$backup"/
  for suffix in -wal -shm; do
    [ ! -e "$legacy$suffix" ] || cp -a "$legacy$suffix" "$backup"/
  done
  echo "backed up both databases to $backup"
}

promote_legacy_database() {
  # VACUUM INTO folds the WAL into a single consistent file.
  sqlite3 "$legacy" "VACUUM INTO '$current'"
  rm -f "$legacy" "$legacy"-wal "$legacy"-shm
  # Imports recorded against the empty 2.x database must apply again.
  rm -f "$sync_state"
}

migrate() {
  opencode service start
  echo "waiting for opencode's V1 migration..."
  for _ in $(seq 600); do
    if [ "$(migration_phase)" = '{"phase":"completed"}' ]; then return; fi
    sleep 1
  done
  die "migration did not complete within 10 minutes; see ~/.local/share/opencode/log/opencode.log"
}

migration_phase() {
  sqlite3 -readonly "$current" "SELECT value FROM kv WHERE key = 'migration.v1-v2'" 2>/dev/null || true
}

report() {
  local legacy_count migrated_count
  legacy_count=$(sqlite3 -readonly "$current" "SELECT count(*) FROM session")
  migrated_count=$(sqlite3 -readonly "$current" "SELECT count(*) FROM session_v2")
  [ "$migrated_count" -ge "$legacy_count" ] || die "only $migrated_count of $legacy_count sessions migrated"
  systemctl --user start opencode-session-sync.timer
  echo "migrated $legacy_count sessions into $current ($migrated_count sessions total)"
}

die() {
  echo "opencode-recover-v1-sessions: $*" >&2
  exit 1
}

main "$@"
