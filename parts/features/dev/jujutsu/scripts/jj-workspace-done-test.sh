set -euo pipefail

export HOME=$TMPDIR XDG_CONFIG_HOME=$TMPDIR/config
export JJ_USER=test JJ_EMAIL=test@example.com
export JJ_CONFIG=$TMPDIR/jj.toml
cat >"$JJ_CONFIG" <<'EOF'
remotes.origin.auto-track-bookmarks = "*"
EOF

main() {
  test_all_refuses_force_and_close_tab
  test_all_dry_run_changes_nothing
  test_all_retires_landed_and_idle_but_keeps_unlanded
  test_all_from_inside_a_retired_workspace
  echo "all jj-workspace-done tests passed"
}

test_all_refuses_force_and_close_tab() {
  new_repo refuse
  if in_dir refuse jj-workspace-done --all --force 2>/dev/null; then fail "--all --force should be refused"; fi
  if in_dir refuse jj-workspace-done --all --close-tab 2>/dev/null; then fail "--all --close-tab should be refused"; fi
}

test_all_dry_run_changes_nothing() {
  new_repo dry
  add_landed_workspace dry dry-landed
  add_idle_workspace dry dry-idle
  in_dir dry jj-workspace-done --all --dry-run
  assert_workspaces dry "default dry-idle dry-landed"
  assert_dir_exists dry-landed
  assert_dir_exists dry-idle
}

test_all_retires_landed_and_idle_but_keeps_unlanded() {
  new_repo full
  add_landed_workspace full landed
  add_idle_workspace full idle
  add_unlanded_workspace full wip
  in_dir full jj-workspace-done --all
  assert_workspaces full "default wip"
  assert_dir_missing landed
  assert_dir_missing idle
  assert_dir_exists wip
  assert_remote_bookmark_missing full workspace/landed
  assert_change_with_description full "feat: wip"
}

test_all_from_inside_a_retired_workspace() {
  new_repo inside
  add_idle_workspace inside inside-idle
  add_idle_workspace inside inside-other
  in_dir inside-idle jj-workspace-done --all
  assert_workspaces inside "default"
  assert_dir_missing inside-idle
  assert_dir_missing inside-other
}

new_repo() {
  git init --quiet --bare "$TMPDIR/$1-origin.git"
  in_dir . jj git init --quiet "$1"
  in_dir "$1" jj git remote add origin "$TMPDIR/$1-origin.git"
  echo base >"$TMPDIR/$1/base.txt"
  in_dir "$1" jj commit --quiet -m init
  in_dir "$1" jj bookmark create --quiet main -r @-
  in_dir "$1" jj git push --quiet --bookmark main
}

add_idle_workspace() {
  in_dir "$1" jj workspace add --quiet "$TMPDIR/$2"
}

add_landed_workspace() {
  add_unlanded_workspace "$1" "$2"
  in_dir "$2" jj bookmark create --quiet "workspace/$2" -r @-
  in_dir "$2" jj git push --quiet --bookmark "workspace/$2"
  in_dir "$2" jj bookmark set --quiet main -r @-
  in_dir "$2" jj git push --quiet --bookmark main
}

add_unlanded_workspace() {
  add_idle_workspace "$1" "$2"
  echo "$2" >"$TMPDIR/$2/$2.txt"
  in_dir "$2" jj commit --quiet -m "feat: $2"
}

in_dir() {
  local dir=$1
  shift
  (cd "$TMPDIR/$dir" && "$@")
}

assert_workspaces() {
  local actual
  actual=$(in_dir "$1" jj workspace list -T 'name ++ "\n"' | sort | paste -sd' ' -)
  [[ "$actual" == "$2" ]] || fail "workspaces of $1: expected '$2', got '$actual'"
}

assert_dir_exists() {
  [[ -d "$TMPDIR/$1" ]] || fail "$1 should still exist"
}

assert_dir_missing() {
  [[ ! -e "$TMPDIR/$1" ]] || fail "$1 should have been removed"
}

assert_remote_bookmark_missing() {
  [[ -z "$(git --git-dir "$TMPDIR/$1-origin.git" branch --list "$2")" ]] || fail "$2 should be deleted on the remote"
}

assert_change_with_description() {
  [[ -n "$(in_dir "$1" jj log --no-graph -r "description(exact:\"$2\n\")" -T 'change_id')" ]] || fail "commit '$2' should survive in $1"
}

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

main "$@"
