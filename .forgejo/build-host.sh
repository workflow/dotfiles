#!/usr/bin/env bash
# Builds one host's toplevel against the checked-out secrets flake. Pushes to
# main and nightly runs leave an out-link in NIX_GCROOTS_DIR, pinning the
# latest build per host as a GC root; pull request builds stay unpinned.
set -euo pipefail

main() {
  local host=${1:?usage: build-host.sh <host> <event>}
  local event=${2:?usage: build-host.sh <host> <event>}
  : "${SECRETS_DIR:?secrets checkout missing}" "${NIX_GCROOTS_DIR:?runner must set NIX_GCROOTS_DIR}"

  if [ "$event" = pull_request ]; then
    build "$host" --no-link
  else
    mkdir -p "$NIX_GCROOTS_DIR"
    build "$host" --out-link "$NIX_GCROOTS_DIR/$host"
  fi
}

build() {
  local host=$1
  shift
  nix build ".#nixosConfigurations.$host.config.system.build.toplevel" \
    --override-input secrets "path:$SECRETS_DIR" \
    --print-build-logs "$@"
}

main "$@"
