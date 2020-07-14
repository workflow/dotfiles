{ config, lib, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    extraConfig = ''
      rofi.opacity: 85
    '';
    font = "Inconsolata 14";
    fullscreen = true;
    theme = "Pop-Dark";
  };
}
