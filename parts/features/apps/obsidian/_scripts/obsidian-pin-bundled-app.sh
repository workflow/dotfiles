set -euo pipefail

config_dir="${1:?usage: obsidian-pin-bundled-app <obsidian-config-dir>}"
config="$config_dir/obsidian.json"

main() {
	mkdir -p "$config_dir"
	disable_self_updates
	remove_downloaded_app_versions
}

disable_self_updates() {
	if [ ! -s "$config" ]; then
		echo '{}' >"$config"
	fi
	if [ "$(jq '.updateDisabled' "$config")" = "true" ]; then
		return
	fi
	local tmp
	tmp="$(mktemp "$config_dir/.obsidian.json.XXXXXX")"
	jq '.updateDisabled = true' "$config" >"$tmp"
	chmod --reference="$config" "$tmp"
	mv "$tmp" "$config"
	echo "[obsidian] disabled self-updates in $config"
}

remove_downloaded_app_versions() {
	local asar
	for asar in "$config_dir"/obsidian-*.asar; do
		[ -e "$asar" ] || continue
		rm -f "$asar"
		echo "[obsidian] removed self-downloaded $asar"
	done
}

main
