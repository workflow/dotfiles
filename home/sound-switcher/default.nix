# Rofi-based sound switcher
{
  pkgs,
  osConfig,
  ...
}: let
  isNumenor = osConfig.networking.hostName == "numenor";
  sound-switcher = pkgs.writers.writeBashBin "sound-switcher" (
    if isNumenor
    then (builtins.readFile ./scripts/sound-switcher-numenor.sh)
    else (builtins.readFile ./scripts/sound-switcher-flexbox.sh)
  );
in {
  home.packages = [sound-switcher];
}
