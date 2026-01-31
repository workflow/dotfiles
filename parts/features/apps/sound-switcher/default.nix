{...}: {
  flake.modules.homeManager.sound-switcher = {pkgs, osConfig, ...}: let
    isNumenor = osConfig.dendrix.hostname == "numenor";
    sound-switcher = pkgs.writers.writeBashBin "sound-switcher" (
      if isNumenor
      then (builtins.readFile ./_scripts/sound-switcher-numenor.sh)
      else (builtins.readFile ./_scripts/sound-switcher-flexbox.sh)
    );
  in {
    home.packages = [sound-switcher];
  };
}
