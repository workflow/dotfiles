wallpapersDir="${HOME}/.local/share/wallpapers"

# Read the current specialisation, default to "dark" if missing
if ! read -r SPEC </etc/specialisation 2>/dev/null; then
	SPEC=dark
fi

case "$SPEC" in
light)
	swaybg -i "${wallpapersDir}/gruvbox-light.png" -m fill
	;;
dark)
	swaybg -i "${wallpapersDir}/gruvbox-dark.png" -m fill
	;;
*)
	swaybg -i "${wallpapersDir}/gruvbox-dark.png" -m fill
	;;
esac
