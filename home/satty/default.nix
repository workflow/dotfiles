{
  isImpermanent,
  lib,
  pkgs,
  ...
}: let
  # Script to take fullscreen screenshot and open with Satty
  sattyScreenshot = pkgs.writeShellApplication {
    name = "satty-screenshot";
    runtimeInputs = with pkgs; [
      satty
      grim
      wl-clipboard
      jq
      niri
    ];
    text = builtins.readFile ./scripts/satty-screenshot.sh;
  };
in {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".cache/satty"
    ];
  };

  home.packages = with pkgs; [
    satty
    sattyScreenshot
  ];
}
