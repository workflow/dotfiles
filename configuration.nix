{ pkgs, ... }:

{ imports = [
    ./nix

    ./system
    ./system/desktop
    ./system/keyboard
    ./system/power
    ./system/fonts

    ./packages
  ];
}
