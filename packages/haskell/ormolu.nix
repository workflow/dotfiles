{ pkgs ? import <nixpkgs> { } }:

let

  src = pkgs.fetchFromGitHub {
    owner = "tweag";
    repo = "ormolu";
    rev = "e966848e524b54b228b3183ab152d3be021291da";
    sha256 = "1qx4c0in8vwf4yybz3sdi7arm9q0ngd3vhadhycgd828z6jjj80k";
  };

in pkgs.haskellPackages.callCabal2nix "ormolu" src { }

