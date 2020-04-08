{ pkgs ? import <nixpkgs> {} }:

let

  src = pkgs.fetchFromGitHub {
    owner = "jaspervdj";
    repo = "patat";
    rev = "3ffdcf7e3258d3d7c9bb11536ea10e674a9e0944";
    sha256 = "1fmh4h501f0vyygh10dc0b4njsrwicpz5nbqcvjykqs94vy7j113";
  };

  patat = pkgs.haskellPackages.callCabal2nix "nixfmt" src {};

in
patat
