{ pkgs ? import <nixpkgs> { } }:

let

  src = pkgs.fetchFromGitHub {
    owner = "tweag";
    repo = "ormolu";
    rev = "f83f6fd1dab5ccbbdf55ee1653b24595c1d653c2";
    sha256 = "1hs7ayq5d15m9kxwfmdac3p2i3s6b0cn58cm4rrqc4d447yl426y";
  };

  ormolu = pkgs.haskellPackages.callCabal2nix "ormolu" src { };

in pkgs.haskell.lib.doJailbreak ormolu
