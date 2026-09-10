# jj-workspace-done: retire the current (secondary) jj workspace once its work
# has landed in trunk(), by direct fast-forward or by a merged forge PR.
#
# Steps: fetch, refuse if anything non-trivial is still outside trunk() (unless
# a merged PR for the workspace bookmark explains it, or --force), delete the
# workspace bookmark locally and on the remote, forget the workspace, abandon
# the straggling commits it leaves behind, delete the checkout, and with
# --close-tab close the Herdr tab it was started from.

main() {
  parse_args "$@"
  locate_workspace
  jj git fetch --quiet
  assert_work_landed
  assert_no_foreign_bookmarks
  delete_workspace_bookmarks
  retire_workspace
  close_herdr_tab
}

force=0
dry=0
close_tab=0
parse_args() {
  for arg in "$@"; do
    case $arg in
      --force) force=1 ;;
      --dry-run) dry=1 ;;
      --close-tab) close_tab=1 ;;
      -h | --help)
        echo "usage: jj-workspace-done [--force] [--dry-run] [--close-tab]"
        exit 0
        ;;
      *) die "unknown argument: $arg" ;;
    esac
  done
}

ws_root=""
main_root=""
ws_name=""
wc_change=""
start_dir=$PWD
locate_workspace() {
  ws_root=$(jj workspace root)
  [[ -f "$ws_root/.jj/repo" ]] || die "$ws_root is the main workspace, not a secondary one; refusing"
  main_root=$(realpath "$ws_root/.jj/$(cat "$ws_root/.jj/repo")/../..")
  [[ "$main_root" != "$ws_root" ]] || die "workspace root equals main root; refusing"
  ws_name=$(jj log -r @ --no-graph -T 'working_copies')
  ws_name=${ws_name%@}
  [[ -n "$ws_name" && "$ws_name" != *@* ]] || die "cannot determine a single workspace name for @ (got '$ws_name')"
  wc_change=$(jj log -r @ --no-graph -T 'change_id')
}

# Commits reachable from @ but not trunk() that carry content or a description.
# Empty, undescribed ones are the working-copy leftovers we are here to remove.
pending_revset() {
  echo "(trunk()..@) ~ (empty() & description(exact:\"\"))"
}

assert_work_landed() {
  local pending
  pending=$(jj log -r "$(pending_revset)" --no-graph -T 'change_id.short() ++ " " ++ description.first_line() ++ "\n"')
  [[ -n "$pending" ]] || return 0
  if pr=$(merged_pr_number); then
    echo "PR #$pr for this workspace is merged; local copies of its commits will be abandoned:"
    echo "$pending"
    return 0
  fi
  if ((force)); then
    echo "--force: abandoning commits not in trunk():" >&2
    echo "$pending" >&2
    return 0
  fi
  die "commits not in trunk() (push main or merge the PR first, or --force):"$'\n'"$pending"
}

merged_pr_number() {
  command -v gh >/dev/null || return 1
  local bookmark number
  for bookmark in $(workspace_bookmark_names); do
    number=$(gh pr list --state merged --head "$bookmark" --json number --jq '.[0].number' 2>/dev/null || true)
    if [[ -n "$number" ]]; then
      echo "$number"
      return 0
    fi
  done
  return 1
}

# The Herdr plugin names its bookmark workspace/<name>; older versions used
# workspace-<name>. Only names that actually exist (locally or remotely) count.
workspace_bookmark_names() {
  local candidate
  for candidate in "workspace/$ws_name" "workspace-$ws_name"; do
    if jj bookmark list --all -T 'name ++ "\n"' | grep -qx -- "$candidate"; then
      echo "$candidate"
    fi
  done
}

assert_no_foreign_bookmarks() {
  local ours foreign
  ours=$(workspace_bookmark_names | paste -sd'|' -)
  foreign=$(jj log -r "(trunk()..@) & bookmarks()" --no-graph -T 'bookmarks ++ "\n"' \
    | tr ' ' '\n' | sed 's/\*$//' | grep -v '^$' | grep -Ev "^(${ours:-^$})$" || true)
  [[ -z "$foreign" ]] || die "other bookmarks sit on this workspace's commits, refusing to abandon them: $foreign"
}

delete_workspace_bookmarks() {
  local bookmark
  for bookmark in $(workspace_bookmark_names); do
    if jj bookmark list -T 'name ++ "\n"' | grep -qx -- "$bookmark"; then
      run jj bookmark delete "$bookmark"
    fi
    if jj bookmark list --all -T 'if(remote, name ++ "\n")' | grep -qx -- "$bookmark"; then
      run jj git push --bookmark "$bookmark" --quiet
    fi
  done
}

# Everything below @ that is not in trunk() is either superseded (merged PR)
# or an empty leftover; abandoning it leaves @ empty on top of trunk(), which
# `workspace forget` then discards by itself once no bookmark pins it.
retire_workspace() {
  run jj abandon --quiet -r "trunk()..@-"
  cd "$main_root"
  run jj workspace forget "$ws_name"
  if change_exists "$wc_change"; then
    run jj abandon --quiet -r "$wc_change"
  fi
  run rm -rf -- "$ws_root"
  echo "retired jj workspace $ws_name ($ws_root)"
}

change_exists() {
  jj log -r "$1" --no-graph -T '""' >/dev/null 2>&1
}

# Closing the tab kills the shell running this script, so it is the last step
# and only happens on request, from a tab that was started inside the
# workspace being retired (Herdr exposes no tab cwd to check against).
close_herdr_tab() {
  ((close_tab)) || return 0
  [[ -n "${HERDR_ENV:-}" && -n "${HERDR_TAB_ID:-}" ]] || die "--close-tab given but not running inside a Herdr tab"
  [[ "$start_dir" == "$ws_root" || "$start_dir" == "$ws_root"/* ]] || die "--close-tab refused: started outside $ws_root"
  run herdr tab close "$HERDR_TAB_ID"
}

run() {
  if ((dry)); then
    echo "+ $*"
  else
    "$@"
  fi
}

die() {
  echo "jj-workspace-done: $*" >&2
  exit 1
}

main "$@"
