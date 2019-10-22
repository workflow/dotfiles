{ pkgs, ... }:

let

  # TODO: build emacs with a pinned nixpkgs
  emacs-27 = pkgs.callPackage ./emacs { };

  niv = pkgs.callPackage ./tools/niv.nix { };
  nixfmt = pkgs.callPackage ./tools/nixfmt.nix { };
  nix-derivation-pretty = pkgs.callPackage ./tools/nix-derivation-pretty.nix { };
  patat = pkgs.callPackage ./tools/patat.nix { };
  pydf = pkgs.callPackage ./tools/pydf.nix { };

  kbconfig = pkgs.callPackage ./scripts/kbconfig.nix { };
  i3lock-wrap = pkgs.callPackage ./scripts/i3lock-wrap { };

in

{
  imports = [ ./tools/tmux.nix ./haskell ./docker ];

  environment.variables.EDITOR = "vim";

  environment.systemPackages = [
    pkgs.acpilight
    pkgs.gnome3.gedit
    pkgs.gnome3.nautilus
    pkgs.htop
    pkgs.i3lock-fancy
    pkgs.playerctl
    pkgs.powertop
    pkgs.redshift

    pkgs.binutils-unwrapped
    pkgs.git
    pkgs.gnumake
    pkgs.gnupg
    pkgs.tree
    pkgs.wget

    pkgs.ag
    pkgs.bat
    pkgs.fzf
    pkgs.pandoc
    pkgs.ripgrep
    pkgs.rofi
    pkgs.scrot
    pkgs.vim

    pkgs.dropbox
    pkgs.evince
    pkgs.google-chrome
    pkgs.spotify
    pkgs.vlc

    pkgs.cachix
    pkgs.direnv
    pkgs.nix-prefetch-git
    pkgs.python37

    # pkgs.dwarf-fortress-packages.dwarf-fortress

    # overlays & custom pkgs
    emacs-27
    nixfmt
    nix-derivation-pretty
    niv
    patat
    pydf

    kbconfig
    i3lock-wrap
  ];
}
