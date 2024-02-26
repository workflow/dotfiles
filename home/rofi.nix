{ config, lib, pkgs, ... }:
{
  programs.rofi = {
    enable = true;

    extraConfig = {
      bw = 1;
      columns = 2;
      icon-theme = "Papirus-Dark";
    };

    theme = "gruvbox-dark-soft";

    font = "Fira Code 12";

    package = pkgs.rofi.override {
      plugins = [ pkgs.rofi-calc pkgs.rofi-emoji ];
    };
  };
}
