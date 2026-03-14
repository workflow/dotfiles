#!/usr/bin/env bash
# Wrapper that mounts a gocryptfs vault before launching Wealthfolio
# and unmounts it on exit. Provides encryption-at-rest for financial data.
#
# Mounts the vault directly at the XDG data path so Wealthfolio
# reads/writes through the FUSE mount transparently.

VAULT_DIR="$HOME/.wealthfolio-vault"
MOUNT_DIR="$HOME/.local/share/com.teymz.wealthfolio"

cleanup() {
    if mountpoint -q "$MOUNT_DIR"; then
        /run/wrappers/bin/fusermount -u "$MOUNT_DIR"
    fi
    # Remove plaintext leftovers from the underlying directory
    rm -rf "${MOUNT_DIR:?}"/*
}

trap cleanup EXIT INT TERM

if mountpoint -q "$MOUNT_DIR"; then
    if pgrep -x Wealthfolio > /dev/null; then
        exec Wealthfolio
    fi
    # Stale mount from a crashed session — clean it up
    /run/wrappers/bin/fusermount -u "$MOUNT_DIR"
fi

password=$(zenity --password --title="Wealthfolio Vault") || exit 0

mkdir -p "$VAULT_DIR" "$MOUNT_DIR"

# First-run: initialize the vault
if [ ! -f "$VAULT_DIR/gocryptfs.conf" ]; then
    echo "$password" | gocryptfs -init -q "$VAULT_DIR"
fi

echo "$password" | gocryptfs -q -nonempty "$VAULT_DIR" "$MOUNT_DIR"
unset password

Wealthfolio &
WEALTHFOLIO_PID=$!
wait "$WEALTHFOLIO_PID" || true

# Also wait for any forked children
while pgrep -x Wealthfolio > /dev/null; do
    sleep 1
done
