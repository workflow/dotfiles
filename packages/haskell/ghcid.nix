{ pkgs ? import <nixpkgs> { } }:

let

  src = pkgs.fetchFromGitHub {
    owner = "ndmitchell";
    repo = "ghcid";
    rev = "40a6ed21bc811e7795c525ce9a4fc689c6b99f60";
    sha256 = "020g3032gggxllnapqf7nbg5wqjg3c2z190f2jx3cl6z0fswgiwz";
  };

in pkgs.haskellPackages.callCabal2nix "ghcid" src { }
