{ pkgs, ... }:

let

  # system
  tpacpi-bat = pkgs.callPackage ../system/power/tpacpi-bat {};
  # applications
  emacs = pkgs.callPackage ./emacs {};

  # various
  var = pkgs.callPackage ./various.nix {};

  customPackages = [
    # system
    tpacpi-bat
    # applications
    emacs

    # various
    var.pydf
  ];

in

{
  imports = [
    ./tmux
    ./bash
    ./haskell

    ./scripts
  ];

  environment.variables.EDITOR = "vim";

  environment.systemPackages = [
    pkgs.ag
    pkgs.fzf
    pkgs.git
    pkgs.htop
    pkgs.rofi
    pkgs.tree
    pkgs.vim
    pkgs.wget
    pkgs.gcc
    pkgs.gnumake
    pkgs.ncurses
    pkgs.binutils

    pkgs.google-chrome
    pkgs.spotify

    pkgs.gnome3.gnome-terminal
    pkgs.i3lock-fancy
    pkgs.powertop
    pkgs.redshift

    pkgs.cachix
  ] ++ customPackages;
}
