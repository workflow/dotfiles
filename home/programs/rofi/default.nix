{
  lib,
  pkgs,
  ...
}: {
  programs.rofi = {
    enable = true;

    extraConfig = {
      bw = 1;
      columns = 2;
      icon-theme = "Papirus-Dark";
      modi = "run,calc,window";
    };

    theme = lib.mkForce "gruvbox-dark-soft";

    plugins = with pkgs; [rofi-calc];

    terminal = "${pkgs.alacritty}/bin/alacritty";
  };

  # for rofi-emoji to insert emojis directly
  home.packages = [pkgs.xdotool];
}
