{ pkgs, ... }:

let

  sources = import ../../nix/sources.nix;
  nixpkgs-master = import sources.nixpkgs-master { };

  ormolu = pkgs.callPackage ./ormolu.nix { };
  brittany = pkgs.callPackage ./brittany.nix { };
  floskell = pkgs.callPackage ./floskell.nix { };

  ghc = pkgs.callPackage ./ghc.nix { };

in {
  environment.systemPackages = [
    pkgs.cabal2nix
    pkgs.cabal-install
    pkgs.ghcid
    nixpkgs-master.hlint
    pkgs.stack

    ormolu
    brittany
    floskell

    ghc.ghc865
    ghc.ghc881
    ghc.ghc865Symlinks
  ];
}
