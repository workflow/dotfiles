{ pkgs ? import <nixpkgs> {} }:

let

  src = pkgs.fetchFromGitHub {
    owner = "nmattia";
    repo = "niv";
    rev = "1dd094156b249586b66c16200ecfd365c7428dc0";
    sha256 = "1b2vjnn8iac5iiqszjc2v1s1ygh0yri998c0k3s4x4kn0dsqik21";
  };

  niv = pkgs.haskellPackages.callCabal2nix "niv" src {};

in
niv
