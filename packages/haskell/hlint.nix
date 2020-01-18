{ pkgs ? import <nixpkgs> { }, overrides ? { } }:

let

  src = pkgs.fetchFromGitHub {
    owner = "ndmitchell";
    repo = "hlint";
    rev = "5f267eb873e349fc010a4a0da7778211853b6f03";
    sha256 = "1dnsf7m8x2ghykgyzpjw0wh53spzcwk4ybg2gmvshvqkvpz9w4zi";
  };

in pkgs.haskellPackages.callCabal2nix "hlint" src overrides
