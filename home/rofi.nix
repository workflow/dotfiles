{ config, lib, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    extraConfig = ''
      rofi.opacity: 85
    '';
    font = "Inconsolata 12";
    fullscreen = true;
    theme = "Pop-Dark";
  };
}
