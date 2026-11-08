set -euo pipefail

usage="usage: obsidian-clear-stale-cache <obsidian-config-dir> <obsidian-store-path>"
config_dir="${1:?$usage}"
package="${2:?$usage}"
stamp="$config_dir/.nix-package"

main() {
	if package_unchanged || obsidian_is_running; then
		return
	fi
	mkdir -p "$config_dir"
	rm -rf "$config_dir/Cache" "$config_dir/Code Cache" "$config_dir/GPUCache"
	echo "$package" >"$stamp"
	echo "[obsidian] cleared Chromium caches for $package" >&2
}

package_unchanged() {
	[ "$(cat "$stamp" 2>/dev/null)" = "$package" ]
}

# A running instance would write its old caches back on exit.
obsidian_is_running() {
	local lock="$config_dir/SingletonLock"
	[ -L "$lock" ] || return 1
	local owner pid
	owner="$(readlink "$lock")"
	pid="${owner##*-}"
	[[ "$pid" =~ ^[0-9]+$ ]] || return 1
	kill -0 "$pid" 2>/dev/null
}

main
