{ pkgs, ... }:

let ghc = pkgs.callPackage ./ghc.nix { };

in {
  environment.systemPackages = [
    pkgs.cabal2nix
    pkgs.cabal-install
    pkgs.ghcid
    # let's test these
    ghc.ghc865
    ghc.ghc881
    ghc.ghc865Symlinks
  ];
}
