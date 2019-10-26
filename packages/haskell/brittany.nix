{ pkgs ? import <nixpkgs> { } }:

let

  src = pkgs.fetchFromGitHub {
    owner = "lspitzner";
    repo = "brittany";
    rev = "38f77f6c5e04883dcbda60286ce88e83275009ab";
    sha256 = "032v7zanl4g9w86akaqim64h1a6g8qlnmhv23xyzg8hma177rr1h";
  };

  brittany = pkgs.haskellPackages.callCabal2nix "brittany" src { };

in pkgs.haskell.lib.doJailbreak brittany
