{ pkgs ? import <nixpkgs> { } }:

let

  sources = import ../../nix/sources.nix;
  nixpkgs-master = import sources.nixpkgs-master { };

  src = pkgs.fetchFromGitHub {
    owner = "ennocramer";
    repo = "floskell";
    rev = "f3a99ce60d2a0d6ca2e66101157c99d0c10fc660";
    sha256 = "150nhdph2v145yagsp7rj2frp66r0hsd84wf2ln9xbnv7vhnkm1g";
  };

  floskell = nixpkgs-master.haskellPackages.callCabal2nix "floskell" src {
    monad-dijkstra = pkgs.haskell.lib.dontCheck
      (pkgs.haskellPackages.callHackage "monad-dijkstra" "0.1.1.2" { });
  };

in nixpkgs-master.haskell.lib.doJailbreak floskell
