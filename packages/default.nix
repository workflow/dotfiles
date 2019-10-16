{ pkgs, ... }:

{
  imports = [ ./tools/tmux.nix ./haskell ./docker ];

  environment.variables.EDITOR = "vim";

  environment.systemPackages = [
    pkgs.acpilight
    pkgs.ag
    pkgs.bat
    pkgs.binutils-unwrapped
    pkgs.fzf
    pkgs.git
    pkgs.gnumake
    pkgs.gnupg
    pkgs.htop
    pkgs.pandoc
    pkgs.playerctl
    pkgs.ripgrep
    pkgs.rofi
    pkgs.scrot
    pkgs.tree
    pkgs.vim
    pkgs.wget

    pkgs.google-chrome
    pkgs.spotify
    pkgs.dropbox

    pkgs.nix-prefetch-git
    pkgs.cachix

    pkgs.gnome3.nautilus
    pkgs.gnome3.gedit
    pkgs.i3lock-fancy
    pkgs.powertop
    pkgs.redshift

    # pkgs.dwarf-fortress-packages.dwarf-fortress

    # overlays
    pkgs.emacs-27
    pkgs.nixfmt
    pkgs.nix-derivation-pretty
    pkgs.niv
    pkgs.patat
    pkgs.pydf

    pkgs.kbconfig
    pkgs.i3lock-wrap
  ];
}
