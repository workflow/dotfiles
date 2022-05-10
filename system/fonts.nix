{ pkgs, ... }:
let
  nixpkgs-unstable = import sources.nixpkgs-unstable { config.allowUnfree = true; };
  sources = import ../nix/sources.nix;
in
{
  fonts.fonts = [
    pkgs.fira-code
    pkgs.fira-code-symbols
    pkgs.font-awesome
    pkgs.font-awesome_4
    pkgs.font-awesome_5
    pkgs.font-awesome-ttf
    (nixpkgs-unstable.nerdfonts.override { fonts = [ "FiraCode" "Inconsolata" ]; })
    pkgs.noto-fonts # For microsoft websites like Github and Linkedin on Chromium browsers
  ];
}
