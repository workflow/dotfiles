{ pkgs ? import <nixpkgs> { } }:

let

  src = pkgs.fetchFromGitHub {
    owner = "tweag";
    repo = "ormolu";
    rev = "d02483a8ab64c658015466693cce38c3c2d55db5";
    sha256 = "0zhc2n5l6vnkxli6v20c82qyshks0bvs2xkb560xahhs1abpcvka";
  };

  ormolu = pkgs.haskellPackages.callCabal2nix "ormolu" src { };

in pkgs.haskell.lib.doJailbreak ormolu
