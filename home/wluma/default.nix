# Automatic brightness adjustment based on screen contents and ALS
{
  lib,
  osConfig,
  ...
}: let
  isFlexbox = osConfig.networking.hostName == "flexbox";
in {
  services.wluma = lib.mkIf isFlexbox {
    enable = true;
  };
}
