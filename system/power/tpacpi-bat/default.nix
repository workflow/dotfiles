{ pkgs ? import <nixpkgs> { } }:

pkgs.tpacpi-bat.overrideAttrs (old: {
  version = "master";
  src = pkgs.fetchFromGitHub {
    owner = "teleshoes";
    repo = "tpacpi-bat";
    rev = "4959b520256cbeb04842f0927e75a63a5ca5030e";
    sha256 = "1w9wzdwy7iladklzwzv8yj1xd9x7q8gi3032db5n54d2q1n3qldn";
  };
})
