{ pkgs, ... }:

let 
  nixpkgs-unstable = import sources.nixpkgs-unstable { config.allowUnfree = true; };
  sources = import ../nix/sources.nix;
in
{
  fonts.fonts = [
    pkgs.fira-code
    pkgs.fira-code-symbols
    pkgs.font-awesome_4
    (nixpkgs-unstable.nerdfonts.override { fonts = ["FiraCode" "Inconsolata"]; })
  ];
}
