{ pkgs, ... }:

let

  sources = import ../nix/sources.nix;
  nixpkgs-unstable = import sources.nixpkgs-unstable { config.allowUnfree = true; };

  #torguard = pkgs.callPackage ./torguard {};

  # TODO: Move whatever we can to home manager modules
  packages =
    [
      pkgs.arandr
      pkgs.asciinema
      pkgs.bind # Provides dig
      pkgs.binutils
      pkgs.bluez
      pkgs.bluez-tools
      pkgs.dconf
      pkgs.deluge
      pkgs.feh
      pkgs.file
      pkgs.fortune
      pkgs.i3status-rust
      pkgs.jq
      pkgs.killall
      pkgs.konsole
      pkgs.ksshaskpass
      pkgs.megacmd
      pkgs.ncdu
      pkgs.niv
      pkgs.patchelf
      pkgs.playerctl
      pkgs.pup
      pkgs.ripgrep
      pkgs.roboto
      pkgs.slack
      pkgs.spideroak
      nixpkgs-unstable.spotify
      pkgs.terminator
      pkgs.unzip
      pkgs.variety
      pkgs.vlc
      pkgs.wget
      pkgs.whois
      pkgs.xclip
      pkgs.yq
    ];

in

packages
