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
      # modi = "run,calc,window";
      modi = "run,window";
    };

    # package = pkgs.rofi-wayland;
    plugins = with pkgs; [rofi-calc];

    terminal = "${pkgs.alacritty}/bin/alacritty";

    theme = lib.mkForce "gruvbox-dark-soft";
  };

  # for rofi-emoji to insert emojis directly
  home.packages = with pkgs; [wtype xdotool];
}
