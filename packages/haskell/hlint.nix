{ pkgs ? import <nixpkgs> { }, overrides ? { } }:

let

  src = pkgs.fetchFromGitHub {
    owner = "ndmitchell";
    repo = "hlint";
    rev = "e6e549f11239d666978a822cde71f14017a5cb7f";
    sha256 = "13vf8h3nwbd8mrfr4wkbbsmqnc3x56znydm6aqg0lk26vak1xjsk";
  };

in pkgs.haskellPackages.callCabal2nix "hlint" src overrides
