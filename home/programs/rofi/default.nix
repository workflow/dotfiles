{ isHidpi, pkgs, ... }:
let
  fontSize = if isHidpi then 24 else 12;
in
{
  programs.rofi = {
    enable = true;

    extraConfig = {
      bw = 1;
      columns = 2;
      icon-theme = "Papirus-Dark";
      modi = "run,calc,emoji,window";
    };

    theme = if isHidpi then ./hidpi-theme.rasi else "gruvbox-dark-soft";

    font = "Fira Code ${toString fontSize}";

    plugins = with pkgs; [ rofi-calc rofi-emoji ];

    terminal = "${pkgs.alacritty}/bin/alacritty";
  };

  # for rofi-emoji to insert emojis directly
  home.packages = [ pkgs.xdotool ];
}
