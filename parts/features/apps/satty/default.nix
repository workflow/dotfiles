{...}: {
  flake.modules.homeManager.satty = {
    osConfig,
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
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
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
