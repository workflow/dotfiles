{ pkgs, ... }:

let

  sources = import ../../nix/sources.nix;
  nixpkgs-master = import sources.nixpkgs-master { };

  ormolu = pkgs.callPackage ./ormolu.nix { };

  ghc = pkgs.callPackage ./ghc.nix { };

in {
  environment.systemPackages = [
    pkgs.cabal2nix
    pkgs.cabal-install
    pkgs.ghcid
    nixpkgs-master.hlint
    pkgs.stack

    ormolu

    ghc.ghc865
    ghc.ghc881
    ghc.ghc865Symlinks
  ];
}
