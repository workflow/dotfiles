{ pkgs, nixpkgs-unstable }:
let
  shebang = "#!${pkgs.bash}/bin/bash";

  ensure-binary-exists = bin: ''
    if ! command -v ${bin} > /dev/null; then
      ${pkgs.xorg.xmessage}/bin/xmessage "'${bin}' not found"
      exit 1
    fi
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

}
