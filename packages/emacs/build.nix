let

  sources = import ../../nix/sources.nix;
  pkgs = import sources.nixpkgs-master { };
  emacs = import ./default.nix { pkgs = pkgs; };

in

  emacs
