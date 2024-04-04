{ pkgs, ... }:
let
  nixpkgs-unstable = pkgs.unstable;
in
{
  fonts.packages = [
    pkgs.fira-code
    pkgs.fira-code-symbols
    pkgs.font-awesome_4
    pkgs.font-awesome_5
    pkgs.font-awesome_6
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
    pkgs.noto-fonts # For microsoft websites like Github and Linkedin on Chromium browsers
  ];
}
