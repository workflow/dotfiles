{ pkgs, ... }:

let

  sources = import ../../nix/sources.nix;
  nixpkgs-master = import sources.nixpkgs-master { };

  brittany = pkgs.callPackage ./brittany.nix { };
  fast-tags = pkgs.callPackage ./fast-tags.nix { };
  floskell = pkgs.callPackage ./floskell.nix { };
  ghcid = pkgs.callPackage ./ghcid.nix { };
  ormolu = pkgs.callPackage ./ormolu.nix { };

  ghc = pkgs.callPackage ./ghc.nix { };

in {
  environment.systemPackages = [
    pkgs.cabal2nix
    pkgs.cabal-install
    nixpkgs-master.hlint
    pkgs.stack

    brittany
    fast-tags
    floskell
    ghcid
    nixpkgs-master.stylish-haskell
    ormolu

    ghc.ghc865
    ghc.ghc881
    ghc.ghc865Symlinks
  ];
}
