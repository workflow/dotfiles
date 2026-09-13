"""Sync opencode sessions between machines as per-session JSON shards.

Each host writes one shard per session into its own directory of a shared
(Syncthing) folder and imports the other hosts' shards with session-level
last-writer-wins. The live SQLite database is never copied.
"""

import argparse
import json
import logging
import os
import re
import socket
import sqlite3
import sys
import time
from collections.abc import Iterable
from dataclasses import dataclass
from pathlib import Path

SHARD_FORMAT = 1
SKIP_TABLES = frozenset({"event"})
DAY_MS = 86_400_000
DEFAULT_DATA_DIR = Path.home() / ".local/share/opencode"
DEFAULT_SYNC_DIR = Path.home() / ".local/share/opencode-sync"
DEFAULT_STATE = Path.home() / ".local/state/opencode-sync/state.json"
IDENTIFIER = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
FILENAME_SAFE = re.compile(r"^[A-Za-z0-9._-]+$")

log = logging.getLogger("opencode-session-sync")


@dataclass(frozen=True)
class Config:
    db: Path
    sync_dir: Path
    host: str
    state: Path
    days: int


def main(argv=None):
    logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s", stream=sys.stderr)
    args = parse_args(argv)
    cfg = config_from_args(args)
    failures = COMMANDS[args.command](cfg)
    return 1 if failures else 0


def sync(cfg):
    return export_sessions(cfg) + import_sessions(cfg)


def export_sessions(cfg):
    db = open_db(cfg.db)
    tables = child_tables(db)
    state = load_state(cfg.state)
    versions = session_versions(db, tables, since_ms(cfg.days))
    owned = {sid: v for sid, v in versions.items() if state["applied"].get(sid) != v}
    host_dir = cfg.sync_dir / cfg.host
    host_dir.mkdir(parents=True, exist_ok=True)
    written = write_changed_shards(db, tables, cfg.host, host_dir, owned, state["exported"])
    prune_own_shards(host_dir, owned.keys())
    state["exported"] = owned
    save_state(cfg.state, state)
    log.info("exported %d shard(s) to %s", written, host_dir)
    return 0


def write_changed_shards(db, tables, host, host_dir, owned, exported):
    written = 0
    for sid, version in owned.items():
        path = shard_path(host_dir, sid)
        if exported.get(sid) == version and path.exists():
            continue
        write_shard_atomically(path, load_shard(db, sid, tables, host, version))
        written += 1
    return written


def prune_own_shards(host_dir, keep_ids):
    keep = set(keep_ids)
    for path in host_dir.glob("*.json"):
        if path.stem not in keep:
            path.unlink()


def import_sessions(cfg):
    db = open_db(cfg.db)
    tables = child_tables(db)
    state = load_state(cfg.state)
    failures = 0
    seen = {}
    for path in foreign_shards(cfg.sync_dir, cfg.host):
        key = f"{path.parent.name}/{path.name}"
        mtime = path.stat().st_mtime_ns
        if state["imported"].get(key) == mtime:
            seen[key] = mtime
            continue
        try:
            import_shard(db, tables, path, state["applied"])
            seen[key] = mtime
        except (ValueError, sqlite3.Error, OSError) as error:
            log.warning("skipping %s: %s", key, error)
            failures += 1
    state["imported"] = seen
    save_state(cfg.state, state)
    return failures


def import_shard(db, tables, path, applied):
    shard = read_shard(path)
    sid = shard["session"]["id"]
    if not should_apply(db, tables, shard):
        return
    apply_shard(db, tables, shard)
    applied[sid] = shard["version"]
    log.info("applied %s from %s (version %d)", sid, shard["host"], shard["version"])


def foreign_shards(sync_dir, own_host):
    if not sync_dir.is_dir():
        return []
    host_dirs = [
        d for d in sorted(sync_dir.iterdir()) if d.is_dir() and d.name != own_host and not d.name.startswith(".")
    ]
    return [path for d in host_dirs for path in sorted(d.glob("*.json"))]


def read_shard(path):
    try:
        shard = json.loads(path.read_text())
    except json.JSONDecodeError as error:
        raise ValueError(f"invalid JSON: {error}") from error
    validate_shard(shard)
    return shard


def validate_shard(shard):
    if not isinstance(shard, dict) or shard.get("format") != SHARD_FORMAT:
        raise ValueError(f"unsupported shard format {shard.get('format') if isinstance(shard, dict) else shard!r}")
    if not isinstance(shard.get("version"), int) or not isinstance(shard.get("host"), str):
        raise ValueError("shard lacks integer version or host")
    if not isinstance(shard.get("session"), dict) or not isinstance(shard["session"].get("id"), str):
        raise ValueError("shard lacks a session row with an id")
    if not isinstance(shard.get("project"), dict):
        raise ValueError("shard lacks a project row")
    children = shard.get("children")
    if not isinstance(children, dict) or not all(isinstance(rows, list) for rows in children.values()):
        raise ValueError("shard children must map table names to row lists")


def should_apply(db, tables, shard):
    sid = shard["session"]["id"]
    local = local_session_version(db, tables, sid)
    return local is None or shard["version"] > local


def apply_shard(db, tables, shard):
    sid = shard["session"]["id"]
    ordered = ordered_by_foreign_keys(db, tables)
    db.execute("BEGIN IMMEDIATE")
    try:
        insert_rows(db, "project", [shard["project"]], "OR IGNORE")
        if shard.get("workspace"):
            insert_rows(db, "workspace", [shard["workspace"]], "OR IGNORE")
        for table in ordered:
            db.execute(f'DELETE FROM "{table}" WHERE session_id = ?', (sid,))
        insert_rows(db, "session", [shard["session"]], "OR REPLACE")
        for table in ordered:
            insert_rows(db, table, shard["children"].get(table, []), "OR REPLACE")
        db.execute("COMMIT")
    except BaseException:
        db.execute("ROLLBACK")
        raise


def insert_rows(db, table, rows, conflict):
    local_columns = table_columns(db, table)
    primary_key = primary_key_columns(db, table)
    for row in rows:
        columns = [c for c in local_columns if c in row]
        missing = set(primary_key) - set(columns)
        if missing:
            raise ValueError(f"{table} row lacks primary key column(s) {sorted(missing)}")
        quoted = ", ".join(f'"{c}"' for c in columns)
        placeholders = ", ".join("?" for _ in columns)
        db.execute(f'INSERT {conflict} INTO "{table}" ({quoted}) VALUES ({placeholders})', [row[c] for c in columns])


def load_shard(db, session_id, tables, host, version):
    session = fetch_one(db, "SELECT * FROM session WHERE id = ?", (session_id,))
    assert session is not None, session_id
    project = fetch_one(db, "SELECT * FROM project WHERE id = ?", (session["project_id"],))
    assert project is not None, session["project_id"]
    workspace = None
    if session["workspace_id"]:
        workspace = fetch_one(db, "SELECT * FROM workspace WHERE id = ?", (session["workspace_id"],))
    children = {t: fetch_all(db, f'SELECT * FROM "{t}" WHERE session_id = ?', (session_id,)) for t in tables}
    return {
        "format": SHARD_FORMAT,
        "host": host,
        "version": version,
        "session": session,
        "project": project,
        "workspace": workspace,
        "children": children,
    }


def session_versions(db, tables, since_ms):
    versions = {r["id"]: r["time_updated"] for r in db.execute("SELECT id, time_updated FROM session")}
    for table in tables_with_time_updated(db, tables):
        for r in db.execute(f'SELECT session_id, MAX(time_updated) AS v FROM "{table}" GROUP BY session_id'):
            sid = r["session_id"]
            if sid in versions:
                versions[sid] = max(versions[sid], r["v"])
    return {sid: v for sid, v in versions.items() if v >= since_ms}


def local_session_version(db, tables, session_id):
    row = fetch_one(db, "SELECT time_updated FROM session WHERE id = ?", (session_id,))
    if row is None:
        return None
    version = row["time_updated"]
    for table in tables_with_time_updated(db, tables):
        r = fetch_one(db, f'SELECT MAX(time_updated) AS v FROM "{table}" WHERE session_id = ?', (session_id,))
        if r["v"] is not None:
            version = max(version, r["v"])
    return version


def tables_with_time_updated(db, tables):
    return [t for t in tables if "time_updated" in table_columns(db, t)]


def child_tables(db):
    names = [r["name"] for r in db.execute("SELECT name FROM sqlite_master WHERE type = 'table'")]
    return sorted(
        t
        for t in names
        if t != "session" and t not in SKIP_TABLES and not t.startswith("sqlite_") and "session_id" in table_columns(db, t)
    )


def ordered_by_foreign_keys(db, tables):
    remaining = list(tables)
    ordered = []
    while remaining:
        ready = [t for t in remaining if referenced_tables(db, t).isdisjoint(remaining)]
        assert ready, f"circular foreign keys among {remaining}"
        ordered.extend(ready)
        remaining = [t for t in remaining if t not in ready]
    return ordered


def referenced_tables(db, table):
    assert IDENTIFIER.match(table), table
    return {r["table"] for r in db.execute(f'PRAGMA foreign_key_list("{table}")')}


def table_columns(db, table):
    return [r["name"] for r in table_info(db, table)]


def primary_key_columns(db, table):
    return [r["name"] for r in sorted(table_info(db, table), key=lambda r: r["pk"]) if r["pk"] > 0]


def table_info(db, table):
    assert IDENTIFIER.match(table), table
    rows = db.execute(f'PRAGMA table_info("{table}")').fetchall()
    assert rows, f"unknown table {table}"
    return rows


def fetch_one(db, sql, params):
    row = db.execute(sql, params).fetchone()
    return None if row is None else dict(row)


def fetch_all(db, sql, params):
    return [dict(r) for r in db.execute(sql, params)]


def open_db(path, timeout=5.0):
    db = sqlite3.connect(path, timeout=timeout, isolation_level=None)
    db.row_factory = sqlite3.Row
    db.execute("PRAGMA foreign_keys = ON")
    return db


def resolve_db_path(explicit, data_dir):
    if explicit is not None:
        return explicit
    candidates = sorted(data_dir.glob("opencode*.db"))
    assert len(candidates) == 1, f"expected exactly one opencode database in {data_dir}, found {candidates}"
    return candidates[0]


def shard_path(host_dir, session_id):
    assert FILENAME_SAFE.match(session_id), session_id
    return host_dir / f"{session_id}.json"


def write_shard_atomically(path, shard):
    write_json_atomically(path, shard)


def load_state(path):
    state = json.loads(path.read_text()) if path.exists() else {}
    for key in ("exported", "imported", "applied"):
        state.setdefault(key, {})
    return state


def save_state(path, state):
    path.parent.mkdir(parents=True, exist_ok=True)
    write_json_atomically(path, state)


def write_json_atomically(path, data):
    tmp = path.with_name(path.name + ".tmp")
    tmp.write_text(json.dumps(data, ensure_ascii=False, separators=(",", ":")))
    os.replace(tmp, path)


def since_ms(days):
    return 0 if days <= 0 else int(time.time() * 1000) - days * DAY_MS


def parse_args(argv):
    parser = argparse.ArgumentParser(prog="opencode-session-sync", description=__doc__)
    common = argparse.ArgumentParser(add_help=False)
    common.add_argument("--db", type=Path, help="opencode database (default: the single opencode*.db in the data dir)")
    common.add_argument("--sync-dir", type=Path, default=DEFAULT_SYNC_DIR, help="shared shard folder")
    common.add_argument("--host", default=socket.gethostname(), help="name of this host's shard directory")
    common.add_argument("--state", type=Path, default=DEFAULT_STATE, help="state file outside the sync folder")
    common.add_argument("--days", type=int, default=90, help="export sessions updated within this many days (0 = all)")
    subparsers = parser.add_subparsers(dest="command", required=True)
    for name, function in COMMANDS.items():
        subparsers.add_parser(name, parents=[common], help=function.__name__.replace("_", " "))
    return parser.parse_args(argv)


def config_from_args(args):
    return Config(
        db=resolve_db_path(args.db, DEFAULT_DATA_DIR),
        sync_dir=args.sync_dir,
        host=args.host,
        state=args.state,
        days=args.days,
    )


COMMANDS = {"sync": sync, "export": export_sessions, "import": import_sessions}


if __name__ == "__main__":
    sys.exit(main())
