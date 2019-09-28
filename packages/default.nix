{ pkgs, ... }:

let

  # system
  tpacpi-bat = pkgs.callPackage ../system/power/tpacpi-bat { };
  # applications
  emacs = pkgs.callPackage ./emacs { };

  # tools
  nixfmt = pkgs.callPackage ./tools/nixfmt.nix { };
  pydf = pkgs.callPackage ./tools/pydf.nix { };

  # scripts
  kbconfig = pkgs.callPackage ./scripts/kbconfig.nix { };

  customPackages = [
    # system
    tpacpi-bat
    # applications
    emacs
    # tools
    nixfmt
    pydf
    # scripts
    kbconfig
  ];

in {
  imports = [
    ./tmux
    ./bash
    ./haskell
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
    pkgs.gnumake
    pkgs.binutils-unwrapped

    pkgs.google-chrome
    pkgs.spotify

    pkgs.gnome3.gnome-terminal
    pkgs.i3lock-fancy
    pkgs.powertop
    pkgs.redshift

    pkgs.nix-prefetch-git
    pkgs.cachix
  ] ++ customPackages;
}
