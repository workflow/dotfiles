# to get the json file:
# nix-prefetch-git https://github.com/NixOS/nixpkgs.git <revision/tag> | tee nixpkgs.json
# current tag is 19.09-beta
{ bootstrap ? import <nixpkgs> { } }:

let

  sources = builtins.fromJSON (builtins.readFile ./sources.json);
  nixos-beta = bootstrap.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    inherit (sources.nixos-beta) rev sha256;
  };

in { nixos-beta = nixos-beta; }
