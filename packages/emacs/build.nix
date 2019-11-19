let

  sources = import ../../nix/sources.nix;
  pkgs = import sources.nixos-beta { };
  emacs = import ./default.nix { pkgs = pkgs; };

in

  emacs
