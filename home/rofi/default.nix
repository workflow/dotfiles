{pkgs, ...}: {
  programs.rofi = {
    enable = true;

    # package = pkgs.rofi-wayland;
    plugins = with pkgs; [rofi-calc];

    terminal = "${pkgs.alacritty}/bin/alacritty";
  };

  # for rofi-emoji to insert emojis directly
  home.packages = with pkgs; [wtype xdotool];
}
