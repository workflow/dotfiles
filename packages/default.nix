{ pkgs, ... }:

let

  # system
  tpacpi-bat = pkgs.callPackage ../system/power/tpacpi-bat {};
  # applications
  emacs = pkgs.callPackage ../applications/emacs {};
  # scripts
  kbconfig = pkgs.callPackage ../scripts/kbconfig {};

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
  environment.systemPackages = [
    pkgs.ag
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
    pkgs.xorg.xsetroot
    pkgs.xscreensaver

    pkgs.cachix
  ] ++ customPackages;
}
