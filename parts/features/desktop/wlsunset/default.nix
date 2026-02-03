# Day/night gamma adjustments for Wayland
{...}: {
  flake.modules.homeManager.wlsunset = {pkgs, ...}: let
    # https://github.com/CyrilSLi/linux-scripts/blob/main/waybar/wlsunset.sh
    wlsunset-waybar = pkgs.writeShellApplication {
      name = "wlsunset-waybar";
      runtimeInputs = with pkgs; [wlsunset procps killall];
      text = builtins.readFile ./_scripts/wlsunset-waybar.sh;
    };
  in {
    home.packages = [
      pkgs.wlsunset
      wlsunset-waybar
    ];
  };
}
