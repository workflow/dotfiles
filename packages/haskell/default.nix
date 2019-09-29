{ pkgs, ... }:

let ghc = pkgs.callPackage ./ghc.nix { };

in {
  environment.systemPackages = [
    pkgs.cabal2nix
    pkgs.cabal-install
    # let's test these
    ghc.ghc863
    ghc.ghc865
    ghc.ghc863Symlinks
  ];
}
