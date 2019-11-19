{ pkgs ? import <nixpkgs> { }, overrides ? { } }:

let

  src = pkgs.fetchFromGitHub {
    owner = "tweag";
    repo = "ormolu";
    rev = "524f8763f3fc3bd338267c0cf5f4aa78f16ee5b1";
    sha256 = "0wxxj34z8yg731jbgrdfnmcwx2w713llrvk76158knvc3bzhs5ja";
  };

in pkgs.haskellPackages.callCabal2nix "ormolu" src overrides
