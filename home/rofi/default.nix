{pkgs, ...}: {
  programs.rofi = {
    enable = true;

    # package = pkgs.rofi-wayland;
    plugins = with pkgs; [rofi-calc];

    terminal = "${pkgs.alacritty}/bin/alacritty";
  };
}
