{ pkgs ? import <nixpkgs> {}, overrides ? {} }:

let

  src = pkgs.fetchFromGitHub {
    owner = "lspitzner";
    repo = "brittany";
    rev = "dab4f0d55798e4737acf057a9cc6109bbc11bfbd";
    sha256 = "0qz0qmnj8h8s3i5x577kxc5nksngbda0zjjb2shj70hjq73q5c8i";
  };

  brittany = pkgs.haskellPackages.callCabal2nix "brittany" src overrides;

in

pkgs.haskell.lib.dontCheck brittany
