{ pkgs, ... }:

let

  sources = import ../../nix/sources.nix;
  nixpkgs-master = import sources.nixpkgs-master { };

  ghc = pkgs.callPackage ./ghc.nix { };

in {
  environment.systemPackages = [
    pkgs.cabal2nix
    pkgs.cabal-install
    pkgs.ghcid
    nixpkgs-master.hlint
    # let's test these
    ghc.ghc865
    ghc.ghc881
    ghc.ghc865Symlinks
  ];
}
