{
  pkgs,
  config,
  isHidpi,
  ...
}: let
  fontSize =
    if isHidpi
    then 24
    else 12;
in {
  programs.rofi = {
    enable = true;

    extraConfig = {
      bw = 1;
      columns = 2;
      icon-theme = "Papirus-Dark";
      modi = "run,calc,window";
    };

    theme =
      if isHidpi
      then ./hidpi-theme.rasi
      else "gruvbox-dark-soft";

    font = "${config.stylix.fonts.monospace.name} ${toString fontSize}";

    plugins = with pkgs; [rofi-calc];

    terminal = "${pkgs.alacritty}/bin/alacritty";
  };

  # for rofi-emoji to insert emojis directly
  home.packages = [pkgs.xdotool];
}
