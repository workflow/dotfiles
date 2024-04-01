{ pkgs, ... }:
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

    plugins = with pkgs; [ rofi-calc rofi-emoji ];
  };

  # for rofi-emoji to insert emojis directly
  home.packages = [ pkgs.xdotool ];
}
