{ pkgs, ... }:

{ imports = [
    ./nix

    ./services/docker

    ./system
    ./system/desktop
    ./system/keyboard
    ./system/power
    ./system/fonts

    ./packages
  ];
}
