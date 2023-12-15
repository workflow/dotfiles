{ pkgs, ... }:
let
  nixpkgs-unstable = pkgs.unstable;
in
{
  fonts.packages = [
    pkgs.fira-code
    pkgs.fira-code-symbols
    pkgs.font-awesome
    pkgs.font-awesome_4
    pkgs.font-awesome_5
    (nixpkgs-unstable.nerdfonts.override { fonts = [ "FiraCode" "Inconsolata" ]; })
    pkgs.noto-fonts # For microsoft websites like Github and Linkedin on Chromium browsers
  ];
}
