{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.cabal2nix
    pkgs.cabal-install
    pkgs.haskell.compiler.ghc863Binary
    pkgs.haskell.compiler.ghc865
  ];
}
