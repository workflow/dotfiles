{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.satty = {
    lib,
    pkgs,
    ...
  }: let
    sattyScreenshot = pkgs.writeShellApplication {
      name = "satty-screenshot";
      runtimeInputs = with pkgs; [
        satty
        grim
        wl-clipboard
        jq
        niri
      ];
      text = builtins.readFile ./_scripts/satty-screenshot.sh;
    };
  in {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".cache/satty"
      ];
    };

    programs.satty = {
      enable = true;
      settings.general = {
        fullscreen = true;
        initial-tool = "crop";
      };
    };

    home.packages = [
      sattyScreenshot
    ];
  };
}
