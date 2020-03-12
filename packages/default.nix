{ pkgs, ... }:

let

  sources = import ../nix/sources.nix;
  nixpkgs-unstable = import sources.nixpkgs-unstable {};

  # TODO: build emacs with a pinned nixpkgs
  emacs-27 = pkgs.callPackage ./emacs { };

  niv = pkgs.callPackage ./tools/niv.nix { };
  nixfmt = pkgs.callPackage ./tools/nixfmt.nix { };
  nix-derivation-pretty = pkgs.callPackage ./tools/nix-derivation-pretty.nix { };
  patat = pkgs.callPackage ./tools/patat.nix { };
  pydf = pkgs.callPackage ./tools/pydf.nix { };

  cookie = pkgs.callPackage ./scripts/cookie.nix { };
  kbconfig = pkgs.callPackage ./scripts/kbconfig.nix { };
  i3lock-wrap = pkgs.callPackage ./scripts/i3lock-wrap { };

  latex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-medium latexmk paralist;
  };

in

{
  imports = [ ./tools/tmux.nix ./haskell ./python ./docker ];

  environment.variables.EDITOR = "vim";

  environment.systemPackages = [
    pkgs.acpilight
    pkgs.gnome3.gedit
    pkgs.gnome3.nautilus
    pkgs.htop
    pkgs.i3lock-fancy
    pkgs.openvpn
    pkgs.pavucontrol
    pkgs.playerctl
    pkgs.powertop
    pkgs.redshift
    pkgs.system-config-printer

    pkgs.binutils-unwrapped
    pkgs.git
    pkgs.gnumake
    pkgs.gnupg
    pkgs.ispell
    pkgs.nixpkgs-fmt
    pkgs.tree
    pkgs.wget
    latex
    pkgs.vscode

    pkgs.ag
    pkgs.bat
    pkgs.exa
    pkgs.fd
    pkgs.fzf
    pkgs.graphviz
    pkgs.mdl
    nixpkgs-unstable.miniserve
    pkgs.pandoc
    pkgs.ripgrep
    pkgs.rofi
    pkgs.scrot
    pkgs.tldr
    pkgs.vim

    pkgs.dropbox
    pkgs.evince
    pkgs.google-chrome
    pkgs.postman
    pkgs.spotify
    pkgs.deluge
    pkgs.vlc

    pkgs.cachix
    pkgs.direnv
    pkgs.nix-prefetch-git

    # pkgs.dwarf-fortress-packages.dwarf-fortress

    # overlays & custom pkgs
    emacs-27
    nixfmt
    nix-derivation-pretty
    niv
    patat
    pydf

    cookie
    kbconfig
    i3lock-wrap
  ];
}
