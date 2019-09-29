{ pkgs ? import <nixpkgs> { }, localLib ? import ../../lib { pkgs = pkgs; } }:

localLib.template ./gitconfig {
  gitignore = ./gitignore;
}
