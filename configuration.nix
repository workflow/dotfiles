{ pkgs, ... }:

{ imports = [
    ./nix

    ./system
    ./system/desktop
    ./system/power
    ./system/fonts

    ./packages
  ];
}
