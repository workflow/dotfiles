{ pkgs, ... }:

let

  sources = import ../nix/sources.nix;
  nixpkgs-unstable = import sources.nixpkgs-unstable {};

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
  pydf = pkgs.callPackage ./tools/pydf.nix {};
  transcribe = pkgs.callPackage ./tools/transcribe.nix {};
  xmonad-build = pkgs.callPackage ./tools/xmonad-build.nix {};

  haskellPackages = pkgs.callPackage ./haskell {};

  packages =
    [
      pkgs.acpilight
      pkgs.gnome3.gedit
      pkgs.gnome3.nautilus
      pkgs.htop
      pkgs.openvpn
      pkgs.pavucontrol
      pkgs.playerctl
      pkgs.powertop
      pkgs.redshift
      pkgs.system-config-printer

      pkgs.bind
      pkgs.binutils-unwrapped
      pkgs.gcolor3
      pkgs.git
      pkgs.gnumake
      pkgs.gnupg
      pkgs.ispell
      pkgs.nixpkgs-fmt
      pkgs.tree
      pkgs.wget
      pkgs.xclip
      pkgs.xorg.xmessage

      latex

      pkgs.ag
      pkgs.bat
      pkgs.exa
      pkgs.fd
      pkgs.fzf
      pkgs.ripgrep
      pkgs.rofi
      pkgs.scrot

      pkgs.graphviz
      pkgs.pandoc
      pkgs.tldr

      pkgs.tmux
      pkgs.vim
      nixpkgs-unstable.tmate

      pkgs.python37
      pkgs.python37Packages.ipython
      pkgs.python37Packages.black

      pkgs.coq

      pkgs.docker-compose

      pkgs.deluge
      pkgs.dropbox
      pkgs.evince
      pkgs.google-chrome
      pkgs.postman
      pkgs.spotify
      pkgs.vlc
      pkgs.zoom-us

      pkgs.audacity
      transcribe

      pkgs.cachix
      pkgs.direnv
      pkgs.nix-prefetch-git

      # pkgs.dwarf-fortress-packages.dwarf-fortress

      # overlays & custom pkgs
      emacs-27
      niv
      patat
      pydf

      indicator-redshift
      indicator-tpacpi

      i3lock-wrap
      kbconfig
      xmonad-build
    ];

in

packages ++ haskellPackages
