{ pkgs ? import <nixpkgs> { } }:

let

  src = pkgs.fetchFromGitHub {
    owner = "pbogdan";
    repo = "nix-derivation-pretty";
    rev = "c39401faf1b628ee28af79883278cf557784d75a";
    sha256 = "05500yf7anccm906a9gww47291q263m3lj2smlk3nj1misc59l1r";
  };

  nix-derivation-pretty =
    pkgs.haskellPackages.callCabal2nix "nix-derivation-pretty" src { };

in pkgs.haskell.lib.doJailbreak nix-derivation-pretty
