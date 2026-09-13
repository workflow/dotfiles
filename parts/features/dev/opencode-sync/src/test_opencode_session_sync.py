import json
import sqlite3
import time
from pathlib import Path

import pytest

import opencode_session_sync as oss

SCHEMA = (Path(__file__).parent / "schema.sql").read_text()
DAY_MS = 86_400_000


def test_child_tables_discovers_session_id_tables_and_skips_event(tmp_path):
    db = make_db(tmp_path, "a")

    tables = oss.child_tables(db)

    assert set(tables) == {
        "message",
        "part",
        "todo",
        "session_share",
        "session_message",
        "session_input",
        "session_context_epoch",
    }


def test_resolve_db_path_asserts_exactly_one_database(tmp_path):
    explicit = tmp_path / "explicit.db"
    assert oss.resolve_db_path(explicit, tmp_path) == explicit

    with pytest.raises(AssertionError):
        oss.resolve_db_path(None, tmp_path)

    (tmp_path / "opencode-stable.db").touch()
    (tmp_path / "opencode-stable.db-wal").touch()
    (tmp_path / "opencode-stable.db-shm").touch()
    assert oss.resolve_db_path(None, tmp_path) == tmp_path / "opencode-stable.db"

    (tmp_path / "opencode.db").touch()
    with pytest.raises(AssertionError):
        oss.resolve_db_path(None, tmp_path)


def test_session_versions_is_max_over_session_and_children(tmp_path):
    db = make_db(tmp_path, "a")
    insert_session(db, "ses_1", t=1000, messages=0)
    insert_message(db, "ses_1", "msg_1", t=1015, part_t=1010)

    versions = oss.session_versions(db, oss.child_tables(db), since_ms=0)

    assert versions == {"ses_1": 1015}


def test_export_writes_one_shard_per_session_atomically(tmp_path):
    cfg = make_config(tmp_path, "a")
    db = make_db(tmp_path, "a")
    insert_session(db, "ses_1", t=1000)
    insert_session(db, "ses_2", t=2000)

    oss.export_sessions(cfg)

    host_dir = cfg.sync_dir / "a"
    assert sorted(p.name for p in host_dir.iterdir()) == ["ses_1.json", "ses_2.json"]
    shard = json.loads((host_dir / "ses_1.json").read_text())
    assert shard["format"] == oss.SHARD_FORMAT
    assert shard["host"] == "a"
    assert shard["version"] == 1000
    assert shard["session"]["id"] == "ses_1"
    assert shard["project"]["id"] == "proj"
    assert len(shard["children"]["message"]) == 2
    assert len(shard["children"]["part"]) == 2


def test_export_skips_unchanged_shard(tmp_path):
    cfg = make_config(tmp_path, "a")
    db = make_db(tmp_path, "a")
    insert_session(db, "ses_1", t=1000)
    oss.export_sessions(cfg)
    shard = cfg.sync_dir / "a" / "ses_1.json"
    before = shard.stat().st_mtime_ns

    time.sleep(0.01)
    oss.export_sessions(cfg)

    assert shard.stat().st_mtime_ns == before


def test_export_rewrites_changed_shard(tmp_path):
    cfg = make_config(tmp_path, "a")
    db = make_db(tmp_path, "a")
    insert_session(db, "ses_1", t=1000)
    oss.export_sessions(cfg)

    insert_message(db, "ses_1", "msg_new", t=5000)
    oss.export_sessions(cfg)

    shard = json.loads((cfg.sync_dir / "a" / "ses_1.json").read_text())
    assert shard["version"] == 5000
    assert len(shard["children"]["message"]) == 3


def test_export_prunes_shard_of_deleted_session(tmp_path):
    cfg = make_config(tmp_path, "a")
    db = make_db(tmp_path, "a")
    insert_session(db, "ses_1", t=1000)
    insert_session(db, "ses_2", t=2000)
    oss.export_sessions(cfg)

    db.execute("DELETE FROM session WHERE id = 'ses_1'")
    db.commit()
    oss.export_sessions(cfg)

    assert sorted(p.name for p in (cfg.sync_dir / "a").iterdir()) == ["ses_2.json"]


def test_export_respects_days_window(tmp_path):
    cfg = make_config(tmp_path, "a", days=30)
    db = make_db(tmp_path, "a")
    now = now_ms()
    insert_session(db, "ses_old", t=now - 100 * DAY_MS)
    insert_session(db, "ses_new", t=now - 1 * DAY_MS)

    oss.export_sessions(cfg)

    assert sorted(p.name for p in (cfg.sync_dir / "a").iterdir()) == ["ses_new.json"]


def test_import_inserts_missing_session_with_children(tmp_path):
    cfg_a, cfg_b = two_hosts(tmp_path)
    db_a = make_db(tmp_path, "a")
    make_db(tmp_path, "b")
    insert_session(db_a, "ses_1", t=1000, title="from a")
    oss.export_sessions(cfg_a)

    failures = oss.import_sessions(cfg_b)

    db_b = oss.open_db(cfg_b.db)
    assert failures == 0
    assert row(db_b, "SELECT title FROM session WHERE id = 'ses_1'")[0] == "from a"
    assert count(db_b, "message", "ses_1") == 2
    assert count(db_b, "part", "ses_1") == 2
    assert row(db_b, "SELECT id FROM project")[0] == "proj"


def test_import_newer_remote_replaces_children(tmp_path):
    cfg_a, cfg_b = two_hosts(tmp_path)
    db_a = make_db(tmp_path, "a")
    db_b = make_db(tmp_path, "b")
    insert_session(db_b, "ses_1", t=1000, messages=2)
    insert_session(db_a, "ses_1", t=1000, messages=0)
    insert_message(db_a, "ses_1", "msg_remote", t=2000)
    oss.export_sessions(cfg_a)

    oss.import_sessions(cfg_b)

    db_b = oss.open_db(cfg_b.db)
    ids = [r[0] for r in db_b.execute("SELECT id FROM message WHERE session_id = 'ses_1'")]
    assert ids == ["msg_remote"]
    assert count(db_b, "part", "ses_1") == 1


def test_import_older_remote_is_ignored(tmp_path):
    cfg_a, cfg_b = two_hosts(tmp_path)
    db_a = make_db(tmp_path, "a")
    db_b = make_db(tmp_path, "b")
    insert_session(db_a, "ses_1", t=1000, title="old")
    insert_session(db_b, "ses_1", t=2000, title="new")
    oss.export_sessions(cfg_a)

    oss.import_sessions(cfg_b)

    db_b = oss.open_db(cfg_b.db)
    assert row(db_b, "SELECT title FROM session WHERE id = 'ses_1'")[0] == "new"


def test_import_never_replaces_existing_project_row(tmp_path):
    cfg_a, cfg_b = two_hosts(tmp_path)
    db_a = make_db(tmp_path, "a")
    db_b = make_db(tmp_path, "b")
    insert_project(db_b, "proj", name="local")
    insert_session(db_a, "ses_1", t=1000, project_name="remote")
    oss.export_sessions(cfg_a)

    oss.import_sessions(cfg_b)

    db_b = oss.open_db(cfg_b.db)
    assert row(db_b, "SELECT name FROM project WHERE id = 'proj'")[0] == "local"


def test_import_round_trips_subagent_session_with_parent_id(tmp_path):
    cfg_a, cfg_b = two_hosts(tmp_path)
    db_a = make_db(tmp_path, "a")
    make_db(tmp_path, "b")
    insert_session(db_a, "ses_parent", t=1000)
    insert_session(db_a, "ses_child", t=1001, parent_id="ses_parent")
    oss.export_sessions(cfg_a)

    oss.import_sessions(cfg_b)

    db_b = oss.open_db(cfg_b.db)
    assert row(db_b, "SELECT parent_id FROM session WHERE id = 'ses_child'")[0] == "ses_parent"


def test_import_skips_corrupt_shard_and_continues(tmp_path):
    cfg_a, cfg_b = two_hosts(tmp_path)
    db_a = make_db(tmp_path, "a")
    make_db(tmp_path, "b")
    insert_session(db_a, "ses_good", t=1000)
    oss.export_sessions(cfg_a)
    (cfg_a.sync_dir / "a" / "ses_bad.json").write_text("{not json")

    failures = oss.import_sessions(cfg_b)

    db_b = oss.open_db(cfg_b.db)
    assert failures == 1
    assert row(db_b, "SELECT id FROM session WHERE id = 'ses_good'") is not None


def test_import_ignores_own_host_dir_and_non_shard_files(tmp_path):
    cfg_a, _ = two_hosts(tmp_path)
    db_a = make_db(tmp_path, "a")
    insert_session(db_a, "ses_1", t=1000)
    oss.export_sessions(cfg_a)
    db_a.execute("DELETE FROM session")
    db_a.commit()
    (cfg_a.sync_dir / "b").mkdir()
    (cfg_a.sync_dir / "b" / "notes.txt").write_text("not a shard")
    (cfg_a.sync_dir / ".stfolder").mkdir()

    failures = oss.import_sessions(cfg_a)

    assert failures == 0
    assert row(db_a, "SELECT id FROM session") is None


def test_import_is_idempotent(tmp_path):
    cfg_a, cfg_b = two_hosts(tmp_path)
    db_a = make_db(tmp_path, "a")
    make_db(tmp_path, "b")
    insert_session(db_a, "ses_1", t=1000)
    oss.export_sessions(cfg_a)
    oss.import_sessions(cfg_b)
    state_before = cfg_b.state.read_text()

    failures = oss.import_sessions(cfg_b)

    assert failures == 0
    assert cfg_b.state.read_text() == state_before
    assert count(oss.open_db(cfg_b.db), "message", "ses_1") == 2


def test_import_tolerates_extra_remote_columns(tmp_path):
    cfg_a, cfg_b = two_hosts(tmp_path)
    db_a = make_db(tmp_path, "a")
    make_db(tmp_path, "b")
    insert_session(db_a, "ses_1", t=1000)
    oss.export_sessions(cfg_a)
    shard_path = cfg_a.sync_dir / "a" / "ses_1.json"
    shard = json.loads(shard_path.read_text())
    shard["session"]["future_column"] = "x"
    shard["children"]["message"][0]["future_column"] = "y"
    shard_path.write_text(json.dumps(shard))

    failures = oss.import_sessions(cfg_b)

    assert failures == 0
    assert count(oss.open_db(cfg_b.db), "message", "ses_1") == 2


def test_locked_db_fails_after_timeout_instead_of_hanging(tmp_path):
    cfg_a, cfg_b = two_hosts(tmp_path)
    db_a = make_db(tmp_path, "a")
    make_db(tmp_path, "b")
    insert_session(db_a, "ses_1", t=1000)
    oss.export_sessions(cfg_a)
    holder = sqlite3.connect(cfg_b.db)
    holder.execute("BEGIN IMMEDIATE")

    with pytest.raises(sqlite3.OperationalError):
        db_b = oss.open_db(cfg_b.db, timeout=0.2)
        shard = oss.read_shard(cfg_a.sync_dir / "a" / "ses_1.json")
        oss.apply_shard(db_b, oss.child_tables(db_b), shard)


def test_sync_reports_nonzero_when_any_shard_fails(tmp_path):
    cfg_a, cfg_b = two_hosts(tmp_path)
    db_a = make_db(tmp_path, "a")
    make_db(tmp_path, "b")
    insert_session(db_a, "ses_good", t=1000)
    oss.export_sessions(cfg_a)
    (cfg_a.sync_dir / "a" / "ses_bad.json").write_text("{not json")

    exit_code = oss.main(cli_args(cfg_b, "sync"))

    assert exit_code == 1
    assert oss.main(cli_args(cfg_b, "sync")) == 1  # the corrupt shard is retried every run


def test_sync_round_trip_returns_zero(tmp_path):
    cfg_a, cfg_b = two_hosts(tmp_path)
    db_a = make_db(tmp_path, "a")
    make_db(tmp_path, "b")
    insert_session(db_a, "ses_1", t=1000)

    assert oss.main(cli_args(cfg_a, "sync")) == 0
    assert oss.main(cli_args(cfg_b, "sync")) == 0

    assert row(oss.open_db(cfg_b.db), "SELECT id FROM session WHERE id = 'ses_1'") is not None


def test_imported_session_is_not_re_exported_until_changed_locally(tmp_path):
    cfg_a, cfg_b = two_hosts(tmp_path)
    db_a = make_db(tmp_path, "a")
    make_db(tmp_path, "b")
    insert_session(db_a, "ses_1", t=1000)
    oss.main(cli_args(cfg_a, "sync"))
    oss.main(cli_args(cfg_b, "sync"))
    assert not (cfg_b.sync_dir / "b" / "ses_1.json").exists()

    insert_message(oss.open_db(cfg_b.db), "ses_1", "msg_b", t=3000)
    oss.main(cli_args(cfg_b, "sync"))

    shard = json.loads((cfg_b.sync_dir / "b" / "ses_1.json").read_text())
    assert shard["version"] == 3000


# --- helpers -----------------------------------------------------------------


def make_db(tmp_path, host):
    path = db_path(tmp_path, host)
    sqlite3.connect(path).executescript(SCHEMA)
    return oss.open_db(path)


def db_path(tmp_path, host):
    return tmp_path / f"{host}.db"


def make_config(tmp_path, host, days=0):
    return oss.Config(
        db=db_path(tmp_path, host),
        sync_dir=tmp_path / "sync",
        host=host,
        state=tmp_path / f"state-{host}.json",
        days=days,
    )


def two_hosts(tmp_path):
    return make_config(tmp_path, "a"), make_config(tmp_path, "b")


def cli_args(cfg, command):
    return [
        command,
        "--db",
        str(cfg.db),
        "--sync-dir",
        str(cfg.sync_dir),
        "--host",
        cfg.host,
        "--state",
        str(cfg.state),
        "--days",
        str(cfg.days),
    ]


def insert_project(db, project_id, name=None):
    db.execute(
        "INSERT OR IGNORE INTO project (id, worktree, vcs, name, time_created, time_updated, sandboxes)"
        " VALUES (?, '/repo', 'git', ?, 0, 0, '[]')",
        (project_id, name),
    )
    db.commit()


def insert_session(db, session_id, t, messages=2, title="title", parent_id=None, project_name=None):
    insert_project(db, "proj", name=project_name)
    db.execute(
        "INSERT INTO session (id, project_id, parent_id, slug, directory, title, version, time_created, time_updated)"
        " VALUES (?, 'proj', ?, 'slug', '/repo', ?, '1.18.29', ?, ?)",
        (session_id, parent_id, title, t, t),
    )
    db.commit()
    for i in range(messages):
        insert_message(db, session_id, f"{session_id}_msg_{i}", t=t)


def insert_message(db, session_id, message_id, t, part_t=None):
    db.execute(
        "INSERT INTO message (id, session_id, time_created, time_updated, data) VALUES (?, ?, ?, ?, '{}')",
        (message_id, session_id, t, t),
    )
    db.execute(
        "INSERT INTO part (id, message_id, session_id, time_created, time_updated, data)"
        " VALUES (?, ?, ?, ?, ?, '{}')",
        (f"{message_id}_part", message_id, session_id, t, part_t if part_t is not None else t),
    )
    db.commit()


def row(db, sql):
    return db.execute(sql).fetchone()


def count(db, table, session_id):
    return db.execute(f"SELECT count(*) FROM {table} WHERE session_id = ?", (session_id,)).fetchone()[0]


def now_ms():
    return int(time.time() * 1000)
