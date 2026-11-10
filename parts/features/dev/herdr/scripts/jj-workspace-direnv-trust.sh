# jj-workspace-direnv-trust: extend the main workspace's direnv approval to the
# current secondary jj workspace, but only for a byte-identical .envrc.
#
# direnv keys every approval by path and content, so each fresh checkout would
# otherwise need its own `direnv allow`. Anything that differs from what was
# approved in the main workspace stays blocked for manual review.

main() {
  locate_workspace
  [[ -f "$ws_root/.envrc" ]] || exit 0
  main_envrc_allowed || skip "the main workspace's .envrc is not allowed"
  cmp -s "$main_root/.envrc" "$ws_root/.envrc" || skip "its .envrc differs from the main workspace's"
  direnv allow "$ws_root"
  echo "jj-workspace-direnv-trust: allowed $ws_root/.envrc (identical to the trusted $main_root/.envrc)"
}

ws_root=""
main_root=""
locate_workspace() {
  ws_root=$(jj workspace root)
  [[ -f "$ws_root/.jj/repo" ]] || die "$ws_root is the main workspace, not a secondary one; refusing"
  main_root=$(realpath "$ws_root/.jj/$(cat "$ws_root/.jj/repo")/../..")
  [[ "$main_root" != "$ws_root" ]] || die "workspace root equals main root; refusing"
}

main_envrc_allowed() {
  (cd "$main_root" && direnv status --json) |
    jq -e --arg rc "$main_root/.envrc" '.state.foundRC.path == $rc and .state.foundRC.allowed == 0' >/dev/null
}

skip() {
  echo "jj-workspace-direnv-trust: leaving $ws_root/.envrc blocked: $*" >&2
  exit 0
}

die() {
  echo "jj-workspace-direnv-trust: $*" >&2
  exit 1
}

main "$@"
