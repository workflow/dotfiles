url=$(ripdrag --target --and-exit | head -n1)

if [ -z "$url" ]; then
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

curl -o "$name" "$url"
