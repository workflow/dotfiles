{ pkgs ? import <nixpkgs> { } }:

let

  src = pkgs.fetchFromGitHub {
    owner = "lspitzner";
    repo = "brittany";
    rev = "fad9db8fd8b138c19a3bceb260bca0fd652a2b73";
    sha256 = "06l7c0ba8asfvkv6xxg3hf9gwjls2fysix8ldsb1rdp9x5ycdpp0";
  };

  brittany = pkgs.haskellPackages.callCabal2nix "brittany" src { };

in pkgs.haskell.lib.doJailbreak brittany
