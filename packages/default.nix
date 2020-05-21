{ pkgs, ... }:

let

  sources = import ../nix/sources.nix;
  nixpkgs-unstable = import sources.nixpkgs-unstable { config.allowUnfree = true; };

  # TODO: build emacs with a pinned nixpkgs
  emacs-27 = pkgs.callPackage ./emacs.nix {};

  latex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-medium
      latexmk
      paralist
      ;
  };

  i3lock-wrap = pkgs.callPackage ./tools/i3lock-wrap {};
  indicator-redshift = pkgs.callPackage ./tools/indicator-redshift {};
  indicator-tpacpi = pkgs.callPackage ./tools/indicator-tpacpi {};
  kbconfig = pkgs.callPackage ./tools/kbconfig.nix {};
  niv = pkgs.callPackage ./tools/niv.nix {};
  nixfmt = pkgs.callPackage ./tools/nixfmt.nix {};
  patat = pkgs.callPackage ./tools/patat.nix {};
  transcribe = pkgs.callPackage ./tools/transcribe.nix {};
  trayer-wrap = pkgs.callPackage ./tools/trayer-wrap.nix {};
  xmonad-build = pkgs.callPackage ./tools/xmonad-build.nix {};

  haskellPackages = pkgs.callPackage ./haskell {};

  dunst = pkgs.dunst.override { dunstify = true; };

  packages =
    [
      nixpkgs-unstable.firefox-devedition-bin
      pkgs.gnome3.cheese
      pkgs.deluge
      pkgs.dropbox
      pkgs.evince
      pkgs.gnome3.gedit
      pkgs.gnome3.nautilus
      pkgs.google-chrome
      pkgs.pavucontrol
      pkgs.postman
      pkgs.spotify
      pkgs.vlc
      pkgs.zoom-us

      pkgs.bind
      pkgs.binutils-unwrapped
      pkgs.docker-compose
      pkgs.gcc
      pkgs.git
      pkgs.gnumake
      pkgs.gnupg
      pkgs.graphviz
      pkgs.htop
      pkgs.openvpn
      pkgs.pandoc
      pkgs.powertop
      pkgs.tree
      pkgs.wget
      pkgs.xclip

      pkgs.bat
      pkgs.direnv
      pkgs.exa
      pkgs.fd
      pkgs.fzf
      pkgs.jq
      pkgs.ripgrep

      emacs-27
      nixpkgs-unstable.tmate
      pkgs.tmux
      pkgs.vim

      dunst
      i3lock-wrap
      pkgs.acpilight
      pkgs.brightnessctl
      pkgs.feh
      pkgs.gcolor3
      pkgs.gnome3.zenity
      pkgs.gsimplecal
      pkgs.libnotify
      pkgs.playerctl
      pkgs.redshift
      pkgs.rofi
      pkgs.scrot
      pkgs.trayer
      pkgs.wmctrl
      pkgs.xorg.xmessage
      trayer-wrap

      nixpkgs-unstable.xmobar
      xmonad-build

      pkgs.audacity
      nixpkgs-unstable.lilypond
      nixpkgs-unstable.musescore
      transcribe

      pkgs.scummvm

      pkgs.python37
      pkgs.python37Packages.black
      pkgs.python37Packages.ipython

      pkgs.coq

      niv
      pkgs.cachix
      pkgs.nix-prefetch-git
      pkgs.nixpkgs-fmt

      indicator-redshift
      indicator-tpacpi
      kbconfig

      latex
      # pkgs.dwarf-fortress-packages.dwarf-fortress
    ];

in

packages ++ haskellPackages
