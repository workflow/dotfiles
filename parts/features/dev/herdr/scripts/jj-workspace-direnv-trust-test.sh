set -euo pipefail

export HOME=$TMPDIR XDG_DATA_HOME=$TMPDIR/data XDG_CONFIG_HOME=$TMPDIR/config
export JJ_USER=test JJ_EMAIL=test@example.com

main() {
  test_identical_envrc_inherits_trust
  test_untrusted_main_leaves_workspace_blocked
  test_changed_envrc_stays_blocked
  test_workspace_without_envrc_is_a_noop
  test_main_workspace_is_refused
  echo "all jj-workspace-direnv-trust tests passed"
}

test_identical_envrc_inherits_trust() {
  new_repo identical
  direnv allow "$TMPDIR/identical"
  add_workspace identical identical-ws
  trust_in identical-ws
  assert_allowed identical-ws
}

test_untrusted_main_leaves_workspace_blocked() {
  new_repo untrusted
  add_workspace untrusted untrusted-ws
  trust_in untrusted-ws
  assert_blocked untrusted-ws
}

test_changed_envrc_stays_blocked() {
  new_repo changed
  direnv allow "$TMPDIR/changed"
  add_workspace changed changed-ws
  echo 'export INJECTED=1' >>"$TMPDIR/changed-ws/.envrc"
  trust_in changed-ws
  assert_blocked changed-ws
}

test_workspace_without_envrc_is_a_noop() {
  new_repo noenvrc
  direnv allow "$TMPDIR/noenvrc"
  add_workspace noenvrc noenvrc-ws
  rm "$TMPDIR/noenvrc-ws/.envrc"
  trust_in noenvrc-ws
  assert_no_envrc_found noenvrc-ws
}

test_main_workspace_is_refused() {
  new_repo mainonly
  direnv allow "$TMPDIR/mainonly"
  if trust_in mainonly 2>/dev/null; then
    fail "running in the main workspace should fail"
  fi
}

new_repo() {
  mkdir "$TMPDIR/$1"
  cd "$TMPDIR/$1"
  jj git init --quiet
  echo 'export FOO=1' >.envrc
  jj commit --quiet -m init
}

add_workspace() {
  cd "$TMPDIR/$1"
  jj workspace add --quiet "$TMPDIR/$2"
  [[ -f "$TMPDIR/$2/.envrc" ]] || fail "workspace $2 did not check out .envrc"
}

trust_in() {
  cd "$TMPDIR/$1"
  jj-workspace-direnv-trust
}

assert_allowed() {
  rc_state "$1" | jq -e '.allowed == 0' >/dev/null || fail "$1/.envrc should be allowed: $(rc_state "$1")"
}

assert_blocked() {
  rc_state "$1" | jq -e '. != null and .allowed != 0' >/dev/null || fail "$1/.envrc should be blocked: $(rc_state "$1")"
}

assert_no_envrc_found() {
  rc_state "$1" | jq -e '. == null' >/dev/null || fail "$1 should have no .envrc: $(rc_state "$1")"
}

rc_state() {
  (cd "$TMPDIR/$1" && direnv status --json) | jq -c '.state.foundRC'
}

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

main "$@"
