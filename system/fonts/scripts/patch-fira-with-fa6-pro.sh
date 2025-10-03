# This script is executed by a Nix-built wrapper (pkgs.writeShellApplication)
# Required tools are provided via runtimeInputs. Do not add Nix-specific paths here.
set -euo pipefail

FA_DIR="$HOME/.local/share/fonts/Font Awesome v6.5.1"
if [ ! -d "$FA_DIR" ]; then
  echo "[patch-fira-with-fa6-pro] Font Awesome 6 Pro not found at: $FA_DIR"
  echo "[patch-fira-with-fa6-pro] Skipping patch step."
  exit 0
fi

OUT_DIR="$HOME/.local/share/fonts/NerdPatched/FiraCodeFAPro"
mkdir -p "$OUT_DIR"

# Fix ownership and permissions to avoid PermissionError from nerd-font-patcher
echo "[patch-fira-with-fa6-pro] Ensuring proper permissions for output directory..."

# Ensure the directory and all its contents are owned by the current user
if [ -d "$OUT_DIR" ]; then
  # Change ownership if needed (may require sudo, but let's try without first)
  if ! [ -O "$OUT_DIR" ]; then
    echo "[patch-fira-with-fa6-pro] WARNING: Output directory not owned by current user"
    echo "[patch-fira-with-fa6-pro] You may need to run: sudo chown -R \"$USER\":\"$USER\" \"$OUT_DIR\""
  fi

  # Ensure directory is writable
  chmod u+w "$OUT_DIR" 2>/dev/null || {
    echo "[patch-fira-with-fa6-pro] ERROR: Cannot make output directory writable: $OUT_DIR" >&2
    echo "[patch-fira-with-fa6-pro] Suggested fix: sudo chown -R \"$USER\":\"$USER\" \"$OUT_DIR\"" >&2
    echo "[patch-fira-with-fa6-pro] Then run: chmod -R u+w \"$OUT_DIR\"" >&2
    exit 1
  }

  # Make existing files writable
  find "$OUT_DIR" -type f -exec chmod u+w {} \; 2>/dev/null || {
    echo "[patch-fira-with-fa6-pro] ERROR: Cannot make existing files writable in $OUT_DIR" >&2
    echo "[patch-fira-with-fa6-pro] Suggested fix: sudo chown -R \"$USER\":\"$USER\" \"$OUT_DIR\"" >&2
    exit 1
  }
fi

# Ensure created files are world-readable
umask 022

# Use a cache-backed temp base to avoid any /tmp quirks
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nerd-font-patcher"
mkdir -p "$CACHE_DIR"

# Try to locate a suitable FA6 Pro Regular font file (otf or ttf)
FA_PRO_FILE="$(find "$FA_DIR" -type f \( -iname '*Pro-Regular-400.*' -o -iname '*Pro-Regular.*' \) | head -n 1 || true)"
if [ -z "${FA_PRO_FILE:-}" ]; then
  echo "[patch-fira-with-fa6-pro] Could not find a 'Font Awesome 6 Pro Regular' font file in: $FA_DIR"
  echo "[patch-fira-with-fa6-pro] Skipping patch step."
  exit 0
fi

# The wrapper sets SRC_DIR to the absolute path for Fira Code TTFs
if [ -z "${SRC_DIR:-}" ] || [ ! -d "$SRC_DIR" ]; then
  echo "[patch-fira-with-fa6-pro] ERROR: SRC_DIR not set or not a directory (expected Fira Code .ttf source)." >&2
  exit 1
fi

echo "[patch-fira-with-fa6-pro] Using FA6 Pro: $FA_PRO_FILE"
echo "[patch-fira-with-fa6-pro] Patching Fira Code fonts from: $SRC_DIR -> $OUT_DIR"

failures=0
set +e
for font in "$SRC_DIR"/*.ttf; do
  base="$(basename "$font")"
  echo "[patch-fira-with-fa6-pro] Patching $base ..."

  # Create a temporary directory for this operation to avoid permission issues
  temp_dir=$(mktemp -d "$CACHE_DIR/patch.XXXXXX")
  temp_output="$temp_dir/output"
  mkdir -p "$temp_output"

  # Copy source font into temp dir to avoid nerd-font-patcher opening read-only Nix store paths with r+b
  # Use a .woff extension to bypass the patcher's head-table tweaking step that opens files r+b
  base_woff="${base%.ttf}.woff"
  src_copy="$temp_dir/$base_woff"
  cp "$font" "$src_copy"
  chmod u+rw "$src_copy" 2>/dev/null || true

  # Run patcher and capture output (do not echo log by default)
  patch_log="$temp_dir/patch.log"
  nerd-font-patcher \
    "$src_copy" \
    --complete \
    --custom "$FA_PRO_FILE" \
    --careful \
    --extension ttf \
    -out "$temp_output" >"$patch_log" 2>&1
  rc=$?

  if [ "$rc" -eq 0 ]; then
    # Move the patched font from temp directory to final destination
    if ls "$temp_output"/*.ttf 1>/dev/null 2>&1; then
      # Show a concise success summary per font
      for f in "$temp_output"/*.ttf; do
        echo "[patch-fira-with-fa6-pro] Generated $(basename "$f")"
      done
      mv "$temp_output"/*.ttf "$OUT_DIR/" || {
        echo "[patch-fira-with-fa6-pro] ERROR: Failed to move patched font for $base" >&2
        rc=1
      }
    else
      echo "[patch-fira-with-fa6-pro] ERROR: No patched font found for $base" >&2
      rc=1
    fi
  fi

  # Clean up temp directory
  rm -rf "$temp_dir"

  if [ "$rc" -ne 0 ]; then
    echo "[patch-fira-with-fa6-pro] ERROR: Patching failed for $base (exit $rc). Log at: $patch_log" >&2
    failures=$((failures + 1))
  fi
done
set -e

# Refresh the font cache so newly patched fonts are available
fc-cache -f "$HOME/.local/share/fonts" || true

if [ "$failures" -gt 0 ]; then
  echo "[patch-fira-with-fa6-pro] Completed with $failures failure(s). See log(s) referenced above." >&2
  exit 1
fi

echo "[patch-fira-with-fa6-pro] Done."
