{ pkgs, ... }:

let

  sources = import ../nix/sources.nix;
  nixpkgs-unstable = import sources.nixpkgs-unstable { config.allowUnfree = true; };

  #torguard = pkgs.callPackage ./torguard {};

  # TODO: Move whatever we can to home manager modules
  packages =
    [
      pkgs.asciinema
      pkgs.binutils
      pkgs.bluez
      pkgs.bluez-tools
      pkgs.deluge
      pkgs.feh
      pkgs.file
      pkgs.fortune
      pkgs.i3status-rust
      pkgs.konsole
      pkgs.ksshaskpass
      pkgs.niv
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
