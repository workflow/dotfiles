{ pkgs, ... }:

{
  imports = [
    ./nix

    ./options/user-symlinks

    ./system
    ./system/shell
    ./system/desktop
    ./system/keyboard
    ./system/power
    ./system/fonts

    ./packages
  ];
}
