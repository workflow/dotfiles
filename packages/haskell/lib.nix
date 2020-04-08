{ pkgs ? import <nixpkgs> {} }:

let

  fetchFromHackage = { name, version, sha256, overrides ? {} }:
    let
      pkg = "${name}-${version}";
      src = fetchTarball {
        url = "https://hackage.haskell.org/package/${pkg}/${pkg}.tar.gz";
        sha256 = sha256;
      };
    in
      pkgs.haskellPackages.callCabal2nix name src overrides;

in
{ fetchFromHackage = fetchFromHackage; }
