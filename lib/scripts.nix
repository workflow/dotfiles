{pkgs}: let
  shebang = "#!${pkgs.bash}/bin/bash";
in {
  dlfile = ''
    ${shebang}
    # Provides the ability to download a file by dropping it into a window

    url=$(dragon -t -x)

    if [ -n "$url" ]; then
      printf "File Name: "
      name=""
      while [ -z $name ] || [ -e $name ]
      do
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

      # Download the file with curl
      [ -n "$name" ] && curl -o "$name" "$url" || exit 1
    else
      exit 1
    fi
  '';

  # Looted from https://gist.github.com/elijahmanor/c10e5787bf9ac6b8c276e47e6745826c, much obliged
  font-smoke-test = ''
    ${shebang}
    set -e

    printf "%b\n" "Normal"
    printf "%b\n" "\033[1mBold\033[22m"
    printf "%b\n" "\033[3mItalic\033[23m"
    printf "%b\n" "\033[3;1mBold Italic\033[0m"
    printf "%b\n" "\033[4mUnderline\033[24m"
    printf "%b\n" "== === !== >= <= =>"
    printf "%b\n" "     󰾆      󱑥 󰒲 󰗼"
  '';

  # Get the current tailscale ip if tailscale is up
  tailscale-ip = ''
    ${shebang}
    set -euo pipefail

    isOnline=$(tailscale status --json | jq -r '.Self.Online')
    if [[ "$isOnline" == "true" ]]; then
      tailscaleIp=$(tailscale status --json | jq -r '.Self.TailscaleIPs[0]')
      echo "{\"icon\": \"tailscale_up\", \"text\": \"$tailscaleIp\", \"state\": \"Good\"}"
    else
      echo "{\"icon\": \"tailscale_down\", \"text\": \"\", \"state\": \"Idle\"}"
    fi
  '';

  # Get the current macgyver status
  macgyver-status = ''
    ${shebang}
    output=$(systemctl status macgyver | grep 'Active:' | awk '{print $2}')

    if [ "$output" = "active" ]; then
      echo "{\"icon\": \"macgyver_up\", \"text\": \"up\", \"state\": \"Good\"}"
    elif [ "$output" = "inactive" ]; then
      echo "{\"icon\": \"macgyver_down\", \"text\": \"down\", \"state\": \"Idle\"}"
    else
      echo "{\"icon\": \"macgyver_up\", \"text\": \"$output\", \"state\": \"Warning\"}"
    fi
  '';
}
