{ pkgs, ... }:

let

  # system
  tpacpi-bat = pkgs.callPackage ../system/power/tpacpi-bat {};
  # applications
  emacs = pkgs.callPackage ./emacs {};
  # scripts
  kbconfig = pkgs.callPackage ./scripts/kbconfig {};

  customPackages = [
    # system
    tpacpi-bat
    # applications
    emacs
    # scripts
    kbconfig
  ];

in

{
  imports = [
    ./tmux
    ./bash
  ];

  environment.variables.EDITOR = "vim";

  environment.systemPackages = [
    pkgs.ag
    pkgs.fzf
    pkgs.git
    pkgs.rofi
    pkgs.tree
    pkgs.vim
    pkgs.wget

    pkgs.google-chrome
    pkgs.spotify

    pkgs.gnome3.gnome-terminal
    pkgs.powertop
    pkgs.redshift
    pkgs.i3lock-fancy

    pkgs.cachix
  ] ++ customPackages;
}
