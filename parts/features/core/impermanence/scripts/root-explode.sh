# Archives the root subvolume into persist/old_roots and replaces it with an empty one.
# Ordering follows https://github.com/nix-community/impermanence/pull/338: a failure must never leave us without a root.

readonly top=/btrfs_tmp
readonly old_roots="$top/persist/old_roots"
readonly max_archive_age_days=30

main() {
    : "${BTRFS_DEVICE:?BTRFS_DEVICE must name the btrfs device holding root, persist and nix}"
    log "Time to 🧨"
    mount_top_level
    if [[ -e "$top/root" ]]; then
        replace_root
    else
        btrfs subvolume create "$top/root"
    fi
    prune_old_roots
    log "Done with 🧨. Au revoir!"
}

log() {
    echo "root-explode: $*" >/dev/kmsg
}

mount_top_level() {
    mkdir -p "$top"
    mount -o subvolid=5 "$BTRFS_DEVICE" "$top"
    trap 'umount "$top"' EXIT
}

replace_root() {
    local archive
    mkdir -p "$old_roots"
    archive=$(unused_archive_path)
    mv -T "$top/root" "$archive"
    # Age archives by when they were archived, so pruning never takes the one we just made
    touch "$archive"
    if ! btrfs subvolume create "$top/root"; then
        mv -T "$archive" "$top/root"
        log "could not create a new root, kept the old one"
        exit 1
    fi
}

unused_archive_path() {
    local base candidate suffix=0
    base="$old_roots/$(date --date="@$(stat -c %Y "$top/root")" "+%Y-%m-%d_%H:%M:%S")"
    candidate=$base
    while [[ -e "$candidate" ]]; do
        suffix=$((suffix + 1))
        candidate="$base.$suffix"
    done
    echo "$candidate"
}

prune_old_roots() {
    local archive
    [[ -d "$old_roots" ]] || return 0
    while IFS= read -r -d '' archive; do
        delete_archive "$archive"
    done < <(find "$old_roots" -mindepth 1 -maxdepth 1 -mtime +"$max_archive_age_days" -print0)
}

# Pruning is housekeeping: it must never fail the boot, and must never touch anything but a subvolume
delete_archive() {
    if ! btrfs subvolume show "$1" >/dev/null 2>&1; then
        log "skipping $1, not a subvolume"
    elif ! btrfs subvolume delete -R "$1"; then
        log "could not delete $1"
    fi
}

main
