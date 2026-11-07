# Renders Claude Code's status line from the session JSON it pipes to stdin.

main() {
  local session model dir used
  session=$(cat)
  model=$(jq -r '.model.display_name' <<<"$session")
  dir=$(jq -r '.workspace.current_dir' <<<"$session")
  # used_percentage is null until the first API response of a session.
  used=$(jq -r '.context_window.used_percentage // 0 | floor' <<<"$session")
  assert_percentage "$used"

  printf '%s%s · %s\n' "$model" "$(jj_segment "$dir")" "$(context_segment "$used")"
}

assert_percentage() {
  if ! [[ $1 =~ ^[0-9]+$ ]] || (($1 > 100)); then
    echo "claude-statusline: invalid context percentage '$1'" >&2
    exit 1
  fi
}

jj_segment() {
  local change
  change=$(current_jj_change "$1") || return 0
  printf ' · \e[35m%s\e[0m' "$change"
}

# --ignore-working-copy: the status line refreshes constantly, and snapshotting
# on every refresh would contend for the working-copy lock with the agent's own jj calls.
current_jj_change() {
  (cd "$1" && jj --ignore-working-copy --no-pager --color never log --no-graph -r @ -T 'change_id.shortest(8)' 2>/dev/null)
}

context_segment() {
  printf '\e[%sm◔ %s%%\e[0m' "$(colour_for_usage "$1")" "$1"
}

colour_for_usage() {
  if (($1 < 50)); then
    echo 32
  elif (($1 < 80)); then
    echo 33
  else
    echo 31
  fi
}

main
