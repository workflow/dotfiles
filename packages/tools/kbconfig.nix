{ pkgs }:

let

  setxkbmap = "${pkgs.xorg.setxkbmap}/bin/setxkbmap";
  xset = "${pkgs.xorg.xset}/bin/xset";
  xcape = "${pkgs.xcape}/bin/xcape";

in

pkgs.writeScriptBin "kbconfig" ''
  #!${pkgs.bash}/bin/bash


  prepare() {
      ${pkgs.killall}/bin/killall xcape || true
      ${setxkbmap} -option  # clear options
      ${setxkbmap} -option ctrl:ralt_rctrl
      ${setxkbmap} -layout us,gr -option grp:alt_space_toggle
      ${xset} r rate 500 45  # not sure if needed
  }

  set_ctrl_and_esc() {
      ${setxkbmap} -option ctrl:nocaps
      ${xcape} "$@" -t 300 -e 'Control_L=Escape'
  }

  set_esc() {
      ${setxkbmap} -option caps:escape
  }

  usage() {
      cat <<EOF
  kbconfig [flags]

  flags:
    --ctrl-esc: set caps to ctrl+esc
    --ctrl-esc-fg: same, but run in foreground (xcape debug mode)
    --esc: set caps to esc
    -h | --help: this help message

  EOF
  }

  case "$1" in
      --ctrl-esc)
          prepare
          set_ctrl_and_esc
          ;;
      --ctrl-esc-fg)
          prepare
          set_ctrl_and_esc -d
          ;;
      --esc)
          prepare
          set_esc
          ;;
      -h | --help)
          usage
          ;;
      *)
          usage
          exit 1
          ;;
  esac
''
