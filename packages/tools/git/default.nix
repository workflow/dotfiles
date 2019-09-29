{ pkgs }:

pkgs.myLib.template ./gitconfig {
  gitignore = ./gitignore;
}
