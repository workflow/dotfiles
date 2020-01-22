{ pkgs ? import <nixpkgs> { }, overrides ? { } }:

let

  src = pkgs.fetchFromGitHub {
    owner = "ndmitchell";
    repo = "hlint";
    rev = "f404c85ef5e14bff6e0216072e04ea040821fbbd";
    sha256 = "0pyiyvn8hc8i59v58k484ph2yqvaai53w8h4ms0x8q9dw0ljj1hr";
  };

in pkgs.haskellPackages.callCabal2nix "hlint" src overrides
