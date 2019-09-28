{ pkgs ? import <nixpkgs> { } }:

let

  src = pkgs.fetchFromGitHub {
    owner = "serokell";
    repo = "nixfmt";
    rev = "921bbd3bb9c95cf2d677a8558b1a27fca6cee597";
    sha256 = "0x08xsjal6db95y1sxxinwv9ks2k6fayvg8435s6zqy7zq42jxm4";
  };

  nixfmt = pkgs.haskellPackages.callCabal2nix "nixfmt" src { };

in pkgs.haskell.lib.doJailbreak nixfmt
