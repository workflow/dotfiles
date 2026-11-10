# jj-workspace-done: retire the current (secondary) jj workspace once its work
# has landed in trunk(), by direct fast-forward or by a merged forge PR.
#
# Steps: fetch, refuse if anything non-trivial is still outside trunk() (unless
# a merged PR for the workspace bookmark explains it, or --force), delete the
# workspace bookmark locally and on the remote, forget the workspace, abandon
# the straggling commits it leaves behind, delete the checkout, and with
# --close-tab close the Herdr tab it was started from.
#
# With --all, do that for every secondary workspace of the repo, keeping (and
# reporting) each one whose work has not landed, and close the Herdr tabs that
# sat entirely inside a retired one.
#
# A stale checkout is brought up to date with `jj workspace update-stale` first
# (only previewed under --dry-run).

main() {
  parse_args "$@"
  if ((all)); then
    retire_all_workspaces
  else
    retire_current_workspace
  fi
}

retire_current_workspace() {
  bring_working_copy_up_to_date
  locate_workspace
  ((no_fetch)) || jj git fetch --quiet
  assert_work_landed
  assert_no_foreign_bookmarks
  delete_workspace_bookmarks
  retire_workspace
  close_herdr_tab
}

force=0
dry=0
close_tab=0
all=0
no_fetch=0
parse_args() {
  for arg in "$@"; do
    case $arg in
      --force) force=1 ;;
      --dry-run) dry=1 ;;
      --close-tab) close_tab=1 ;;
      --all) all=1 ;;
      --no-fetch) no_fetch=1 ;;
      -h | --help)
        echo "usage: jj-workspace-done [--force] [--dry-run] [--close-tab] [--no-fetch]"
        echo "       jj-workspace-done --all [--dry-run] [--no-fetch]"
        exit 0
        ;;
      *) die "unknown argument: $arg" ;;
    esac
  done
  if ((all && (force || close_tab))); then
    die "--all cannot be combined with --force or --close-tab"
  fi
}

# Each workspace is retired by a separate run of this script: bash disables
# errexit inside an `if` condition, so an in-process attempt could reach
# `rm -rf` after a failed step.
retire_all_workspaces() {
  local workspaces name root
  local -a retired=() kept=()
  if is_stale; then
    jj_flags=(--ignore-working-copy)
  fi
  workspaces=$(jj workspace list -T 'name ++ "\t" ++ root ++ "\n"')
  ((no_fetch)) || jj git fetch --quiet
  while IFS=$'\t' read -r name root; do
    [[ -n "$name" && -n "$root" ]] || die "unparseable workspace list entry: '$name' '$root'"
    is_secondary_workspace "$root" || continue
    echo "== $name ($root)"
    if retire_in_child "$root"; then
      retired+=("$name")
      close_herdr_tabs_inside "$root"
    else
      kept+=("$name")
    fi
  done <<<"$workspaces"
  report_all "${#retired[@]}" "${kept[@]}"
}

is_secondary_workspace() {
  [[ ! -d "$1/.jj/repo" ]]
}

retire_in_child() {
  local -a args=(--no-fetch)
  ((dry)) && args+=(--dry-run)
  [[ -d "$1" ]] || {
    echo "jj-workspace-done: $1 is missing on disk; run \`jj workspace forget\` for it" >&2
    return 1
  }
  (cd "$1" && "$self" "${args[@]}")
}

# Tabs whose every pane sits in the retired checkout are left with shells in a
# deleted directory. The tab running this script is spared so the run can
# finish and report.
close_herdr_tabs_inside() {
  local root=$1 tab tabs
  command -v herdr >/dev/null || return 0
  if ! tabs=$(tabs_entirely_inside "$root"); then
    echo "jj-workspace-done: could not list Herdr panes; tabs in $root left open" >&2
    return 0
  fi
  for tab in $tabs; do
    if [[ "$tab" == "${HERDR_TAB_ID:-}" ]]; then
      echo "left this Herdr tab ($tab) open; it is running jj done"
      continue
    fi
    run herdr tab close "$tab"
  done
}

tabs_entirely_inside() {
  herdr pane list | jq -r --arg root "$1" '
    .result.panes
    | group_by(.tab_id)[]
    | select(all(.cwd == $root or (.cwd | startswith($root + "/"))))
    | .[0].tab_id'
}

report_all() {
  local retired_count=$1
  shift
  local verb="retired"
  ((dry)) && verb="would retire"
  echo "$verb $retired_count workspace(s); kept $#${*:+: $*}"
}

# A stale checkout (its @ was rewritten from another workspace) blocks every
# jj command that snapshots. update-stale keeps unrecorded edits by recording
# them in a divergent sibling of @, which the landed-work check cannot see, so
# a divergent @ afterwards means: keep the workspace.
bring_working_copy_up_to_date() {
  is_stale || return 0
  if ((dry)); then
    echo "stale working copy: would run \`jj workspace update-stale\` first; previewing jj's recorded state (edits on disk are not checked)"
    jj_flags=(--ignore-working-copy)
    return 0
  fi
  jj workspace update-stale
  assert_working_copy_not_divergent
}

is_stale() {
  local err
  if err=$(jj status 2>&1 >/dev/null); then
    return 1
  fi
  [[ "$err" == *"working copy is stale"* ]] || die "jj status failed: $err"
}

assert_working_copy_not_divergent() {
  [[ "$(jj log -r @ --no-graph -T 'divergent')" == false ]] ||
    die "update-stale saved edits jj had not seen yet into a divergent copy of @; review them with \`jj log -r 'change_id(@)'\`, keep or abandon that copy, then rerun"
}

# Global jj flags for this run; set to --ignore-working-copy where the
# checkout must not (or cannot) be snapshotted.
jj_flags=()
jj() {
  command jj "${jj_flags[@]}" "$@"
}

ws_root=""
main_root=""
ws_name=""
wc_change=""
start_dir=$PWD
self=$(realpath "${BASH_SOURCE[0]}")
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
  if ((dry)); then
    echo "would retire jj workspace $ws_name ($ws_root)"
  else
    echo "retired jj workspace $ws_name ($ws_root)"
  fi
}

change_exists() {
  jj log -r "$1" --no-graph -T '""' >/dev/null 2>&1
}

# Closing the tab kills the shell running this script, so it is the last step
# and only happens on request, from a tab that was started inside the
# workspace being retired.
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
