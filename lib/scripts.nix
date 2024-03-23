{ pkgs, nixpkgs-unstable }:
let
  shebang = "#!${pkgs.bash}/bin/bash";

  ensure-binary-exists = bin: ''
    if ! command -v ${bin} > /dev/null; then
      ${pkgs.xorg.xmessage}/bin/xmessage "'${bin}' not found"
      exit 1
    fi
  '';

  ensure-env-var = var:
    let v = "$" + "${var}"; in
    ''
      [ -z "${v}" ] && echo "${var} is not set" && exit 1
    '';

in
{
  # Declaratively configure Mega backups
  configure-mega-backup =
    let
      period = "7d";
      numBackups = "6";
    in
    ''
      ${shebang}

      set -euo pipefail

      hostname="$(hostname)"

      ${pkgs.megacmd}/bin/mega-mkdir -p "/backup/$hostname/Documents" >/dev/null || true
      ${pkgs.megacmd}/bin/mega-backup ~/Documents "/backup/$hostname/Documents" --period="${period}" --num-backups=${numBackups}

      ${pkgs.megacmd}/bin/mega-mkdir -p "/backup/$hostname/Videos" >/dev/null || true
      ${pkgs.megacmd}/bin/mega-backup ~/Videos "/backup/$hostname/Videos" --period="${period}" --num-backups=${numBackups}

      ${pkgs.megacmd}/bin/mega-mkdir -p "/backup/$hostname/Music" >/dev/null || true
      ${pkgs.megacmd}/bin/mega-backup ~/Music "/backup/$hostname/Music" --period="${period}" --num-backups=${numBackups}

      ${pkgs.megacmd}/bin/mega-mkdir -p "/backup/$hostname/Pictures" >/dev/null || true
      ${pkgs.megacmd}/bin/mega-backup ~/Pictures "/backup/$hostname/Pictures" --period="${period}" --num-backups=${numBackups}

      ${pkgs.megacmd}/bin/mega-mkdir -p "/backup/$hostname/.backup" >/dev/null || true
      ${pkgs.megacmd}/bin/mega-backup ~/.backup "/backup/$hostname/.backup" --period="${period}" --num-backups=${numBackups}

      ${pkgs.megacmd}/bin/mega-mkdir -p "/backup/$hostname/Jetbrains" >/dev/null || true
      ${pkgs.megacmd}/bin/mega-backup ~/.config/JetBrains "/backup/$hostname/Jetbrains" --period="${period}" --num-backups=${numBackups}
      ${pkgs.megacmd}/bin/mega-mkdir -p "/backup/$hostname/BraveSoftware" >/dev/null || true
      ${pkgs.megacmd}/bin/mega-backup ~/.config/BraveSoftware "/backup/$hostname/BraveSoftware" --period="${period}" --num-backups=${numBackups}
    '';

  gen-gitignore = ''
    ${shebang}
    set -e

    comma-sep() {
        local IFS=","
        echo "$*"
    }

    main() {
        if [ $# -eq 0 ]; then
            echo "No languages specified"
            exit 1
        fi
        languages="$(comma-sep $@)"
        ${pkgs.wget}/bin/wget -O- "http://gitignore.io/api/$languages" 2> /dev/null
    }

    main "$@"
  '';

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

  # Get the current tailscale ip if tailscale is up
  tailscale-ip = ''
    ${shebang}
    set -euo pipefail

    isOnline=$(tailscale status --json | jq -r '.Self.Online')
    if [[ "$isOnline" == "true" ]]; then
      tailscaleIp=$(tailscale status --json | jq -r '.Self.TailscaleIPs[0]')
      echo "$tailscaleIp"
    fi
  '';

  # Get the current macgyver status
  macgyver-status = ''
    ${shebang}
    set -euo pipefail
    output=$(systemctl status macgyver | grep 'Active:' | awk '{print $2}')

    if [ "$output" = "active" ]; then
        echo "up"
    elif [ "$output" = "inactive" ]; then
        echo "down"
    else
        echo "$output"
    fi
  '';

  nixos = ''
    ${shebang}
    usage() {
        cat <<EOF
    Run nixos commands
    Usage:
      -b, --build, b, build:      Build nixos configuration
      -s, --switch, s, switch:    Build nixos configuration and switch to it
      -h, --help, h, help:        This help message
    EOF
    }
    ${ensure-env-var "NIXOS_CONFIG"}
    build() {
        sudo nixos-rebuild test --flake "$NIXOS_CONFIG#"
    }
    switch() {
        sudo nixos-rebuild switch --flake "$NIXOS_CONFIG#"
    }
    case "$1" in
        -b | --build | b | build)
            build
            ;;
        -s |--switch | s | switch)
            switch
            ;;
        -h | --help | h | help)
            usage
            ;;
        *)
            usage
            exit 1
            ;;
    esac
  '';

}
