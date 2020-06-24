{ pkgs, ... }:

let

  sources = import ../nix/sources.nix;
  nixpkgs-unstable = import sources.nixpkgs-unstable { config.allowUnfree = true; };

  #emacs-27 = pkgs.callPackage ./emacs.nix {};

  #i3lock-wrap = pkgs.callPackage ./tools/i3lock-wrap {};

  # TODO: Move whatever we can to home manager modules
  packages =
    [
      pkgs.asciinema
      pkgs.binutils
      pkgs.bluez
      pkgs.bluez-tools
      pkgs.feh
      pkgs.fortune
      pkgs.i3status-rust
      pkgs.konsole
      pkgs.ksshaskpass
      pkgs.patchelf
      pkgs.playerctl
      pkgs.ripgrep
      pkgs.roboto
      pkgs.spideroak
      pkgs.spotify
      pkgs.terminator
      pkgs.variety
      pkgs.wget
    ];

in

packages
