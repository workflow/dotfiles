{...}: {
  flake.modules.homeManager.wlsunset = {pkgs, ...}: let
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
