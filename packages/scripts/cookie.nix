{ pkgs }:

let

  myLib = pkgs.callPackage ../../lib.nix {};

in

myLib.shellScript "cookie" ''
  #!${pkgs.bash}/bin/bash

  usage() {
      echo "Create a project from a cookiecutter template

  Usage:
      -c, --cutter Select and run cutter
      -l, --list   List available cutters
      -h, --help   This help message
  "
  }

  list-cutters() {
      for k in "''${!cutters[@]}"; do
          echo "$k: ''${cutters[$k]}"
      done
  }

  # cookiecutter() {
  #     nix-shell -p cookiecutter --command "cookiecutter gh:alexpeits/$1"
  # }

  github() {
      declare -r user="$1"
      declare -r repo="$2"
      echo "gh:$user/$repo"
  }

  run-cutter() {
      cutter="''${cutters[$1]}"
      ${pkgs.cookiecutter}/bin/cookiecutter "$cutter"
  }

  declare -r -A cutters=(
      [haskell]="$(github alexpeits haskell-nix-cookiecutter)"
      [hs]="$(github alexpeits haskell-nix-cookiecutter)"
  )


  case "$1" in
      -h | --help)
          usage
          ;;
      -l | --list)
          list-cutters
          ;;
      -c | --cutter)
          shift
          run-cutter "$1"
          ;;
      *)
          usage
          exit 1
          ;;
  esac
''
