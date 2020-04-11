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
  em =
    let
      wsp = "wsp-term";
      emacs = pkgs.callPackage ../packages/emacs.nix {};
    in
      ''
        ${shebang}

        if [ $# -eq 0 ]; then
            args="."
        else
            args="$@"
        fi

        ${emacs}/bin/emacsclient -c -t -s ${wsp} $args || \
          (${emacs}/bin/emacs --daemon=${wsp} && ${emacs}/bin/emacsclient -c -t -s ${wsp} $args)
      '';

  xfce-manage =
    let
      xfconf-query = "${pkgs.xfce.xfconf}/bin/xfconf-query";
    in
      ''
        ${shebang}
        usage() {
            cat <<EOF
        Usage: xfce-manage [mode]

        available modes:

          --dpi      toggle dpi
          --panel    toggle panel size

        EOF
        }

        toggle_dpi() {
            declare -r query="${xfconf-query} -c xsettings -p /Xft/DPI"
            declare -r small="83"
            declare -r medium="-1"
            declare -r large="110"
            declare -r cur="$(eval $query)"

            if [ "$cur" == "$medium" ]; then
                eval "$query -s $large"
            elif [ "$cur" == "$large" ]; then
                eval "$query -s $small"
            else
                eval "$query -s $medium"
            fi
        }

        toggle_panel_size() {
            declare -r query="${xfconf-query} -c xfce4-panel -p /panels/panel-1/size"
            declare -r small="24"
            declare -r large="36"
            declare -r cur="$(eval $query)"

            if [ "$cur" == "$small" ]; then
                eval "$query -s $large"
            else
                eval "$query -s $small"
            fi
        }

        case "$1" in
            --dpi)
                toggle_dpi
                ;;
            --panel)
                toggle_panel_size
                ;;
            -h | --help)
                usage
                ;;
            *)
                usage
                exit 1
                ;;
        esac
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

  cookie = ''
    ${shebang}

    usage() {
        echo "Create a project from a cookiecutter template

    Usage:
        -c, --cutter Select and run cutter
        -l, --list   List available cutters
        -h, --help   This help message
    "
    }

    list-cutters() {
        for k in "''${!cutters[@]}"; do
            echo "$k: ''${cutters[$k]}"
        done
    }

    github() {
        declare -r user="$1"
        declare -r repo="$2"
        echo "gh:$user/$repo"
    }

    run-cutter() {
        cutter="''${cutters[$1]}"
        ${pkgs.cookiecutter}/bin/cookiecutter "$cutter"
    }

    declare -r -A cutters=(
        [haskell]="$(github alexpeits haskell-nix-cookiecutter)"
        [hs]="$(github alexpeits haskell-nix-cookiecutter)"
    )


    case "$1" in
        -h | --help)
            usage
            ;;
        -l | --list)
            list-cutters
            ;;
        -c | --cutter)
            shift
            run-cutter "$1"
            ;;
        *)
            usage
            exit 1
            ;;
    esac
  '';

  xmonad-init = ''
    ${shebang}
    ${ensure-binary-exists "xmonad"}
    xmonad --replace
  '';
}
