# to get the json file:
# nix-prefetch-git https://github.com/NixOS/nixpkgs.git <revision/tag> | tee nixpkgs.json
# current tag is 19.09-beta
{ bootstrap ? import <nixpkgs> { } }:

let

  nixpkgs = builtins.fromJSON (builtins.readFile ./nixpkgs.json);
  src = bootstrap.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    inherit (nixpkgs) rev sha256;
  };

in import src { }
