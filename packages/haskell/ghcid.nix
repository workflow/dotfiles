{ pkgs ? import <nixpkgs> { } }:

let

  src = pkgs.fetchFromGitHub {
    owner = "ndmitchell";
    repo = "ghcid";
    rev = "b3b376e42389463ffc5e450af40f79d6b6343a17";
    sha256 = "08gvkgmka199vxkxxgdlwk9hacqm8b9icycl4ddglx0sn6w6y9vg";
  };

in pkgs.haskellPackages.callCabal2nix "ghcid" src { }
