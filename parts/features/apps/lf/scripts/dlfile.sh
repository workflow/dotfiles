# ripdrag prints gio's parse_name() for each drop: local files (including
# browser image drags, which hand over the cached file) arrive as plain
# paths, remote link drags as URIs. Strip the \r that text/uri-list line
# endings leak through, since curl rejects control characters.
src=$(ripdrag --target --and-exit | head -n1 | tr -d '\r')

if [ -z "$src" ]; then
  exit 1
fi

printf "File Name: "
name=""
while [ -z "$name" ] || [ -e "$name" ]; do
  read -r name
  if [ -e "$name" ]; then
    printf "File already exists, overwrite (y|n): "
    read -r ans

    if [ "$ans" = "y" ]; then
      break
    else
      printf "File Name: "
    fi
  fi
done

if [ -z "$name" ]; then
  exit 1
fi

if [ -e "$src" ]; then
  cp -- "$src" "$name"
else
  curl -fLo "$name" "${src// /%20}"
fi
