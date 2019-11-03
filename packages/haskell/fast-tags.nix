{ pkgs ? import <nixpkgs> { } }:

let

  src = pkgs.fetchFromGitHub {
    owner = "elaforge";
    repo = "fast-tags";
    rev = "43de8f4eb0266757414cf70576a4aec21d9fc9e5";
    sha256 = "0868k4w5s771yqmi4hsz09f3d21whl7s85mmnldk3fz2aiqdffgf";
  };

in pkgs.haskellPackages.callCabal2nix "fast-tags" src { }

