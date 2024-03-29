{ pkgs, nixpkgs-unstable }:
let
  shebang = "#!${pkgs.bash}/bin/bash";

  ensure-env-var = var:
    let v = "$" + "${var}"; in
    ''
      [ -z "${v}" ] && echo "${var} is not set" && exit 1
    '';

in
{
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
