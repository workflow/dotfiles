# https://github.com/sentriz/cliphist/blob/master/contrib/cliphist-fuzzel-img
thumbnail_size=64
thumbnail_dir="${XDG_CACHE_HOME:-$HOME/.cache}/cliphist/thumbnails"

cliphist_list=$(cliphist list)
if [ -z "$cliphist_list" ]; then
	fuzzel -d --placeholder "cliphist: please store something first" --lines 0
	rm -rf "$thumbnail_dir"
	exit
fi

[ -d "$thumbnail_dir" ] || mkdir -p "$thumbnail_dir"

# Write square shaped thumbnail to cache if it doesn't exist
read -r -d '' thumbnail <<EOF
/^[0-9]+\s<meta http-equiv=/ { next }
match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
  cliphist_item_id=grp[1]
  ext=grp[3]
  thumbnail_file=cliphist_item_id"."ext
  system("[ -f ${thumbnail_dir}/"thumbnail_file" ] || echo " cliphist_item_id "\\\\\t | cliphist decode | magick - -thumbnail ${thumbnail_size}^ -gravity center -extent ${thumbnail_size} ${thumbnail_dir}/"thumbnail_file)
  print \$0"\0icon\x1f${thumbnail_dir}/"thumbnail_file
  next
}
1
EOF

item=$(echo "$cliphist_list" | gawk "$thumbnail" | fuzzel -d --placeholder "Search clipboard..." --counter --no-sort --with-nth 2)
exit_code=$?

# ALT+0 to clear history
if [ "$exit_code" -eq 19 ]; then
	confirmation=$(echo -e "No\nYes" | fuzzel -d --placeholder "Delete history?" --lines 2)
	[ "$confirmation" == "Yes" ] && rm ~/.cache/cliphist/db && rm -rf "$thumbnail_dir"
else
	[ -z "$item" ] || echo "$item" | cliphist decode | wl-copy
fi

# Delete cached thumbnails that are no longer in cliphist db
find "$thumbnail_dir" -type f | while IFS= read -r thumbnail_file; do
	cliphist_item_id=$(basename "${thumbnail_file%.*}")
	if ! grep -q "^${cliphist_item_id}\s\[\[ binary data" <<<"$cliphist_list"; then
		rm "$thumbnail_file"
	fi
done
