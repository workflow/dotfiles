{ pkgs }:

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
  emacsclient =
    let
      wsp = "wsp-term";
      emacs = pkgs.callPackage ../packages/emacs.nix {};
    in
      ''
        ${shebang}

        ${emacs}/bin/emacsclient -c -t -s ${wsp} $* || \
          (${emacs}/bin/emacs --daemon=${wsp} && \
             ${emacs}/bin/emacsclient -c -t -s ${wsp} $*)
      '';

  dpi = ''
    ${shebang}
    declare -r query="${pkgs.xfce.xfconf}/bin/xfconf-query -c xsettings -p /Xft/DPI"
    declare -r lo="83"
    declare -r off="-1"
    declare -r hi="110"

    get() {
        declare -r cur="$(eval $query)"
        echo -ne $cur
    }

    set() {
        declare -r new="$1"
        eval "$query -s $new"
    }

    toggle() {
        declare -r cur="$(get)"
        if [ "$cur" == "$off" ]; then
            set "$hi"
        elif [ "$cur" == "$hi" ]; then
            set "$lo"
        else
            set "$off"
        fi
    }

    toggle
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

  xmonad-init = ''
    ${shebang}
    ${ensure-binary-exists "xmonad"}
    xmonad --replace
  '';
}
