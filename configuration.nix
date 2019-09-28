{ pkgs, ... }:

{
  imports = [
    ./nix

    ./services/docker

    ./system
    ./system/shell
    ./system/desktop
    ./system/keyboard
    ./system/power
    ./system/fonts

    ./packages
  ];
}
