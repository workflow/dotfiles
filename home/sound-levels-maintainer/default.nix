# Maintain input/output gain/volume levels
{
  pkgs,
  osConfig,
  ...
}: let
  isBoar = osConfig.networking.hostName == "boar";
  sound-levels-maintainer = pkgs.writers.writeBashBin "sound-levels-maintainer" (
    if isBoar
    then (builtins.readFile ./scripts/sound-levels-maintainer-boar.sh)
    else (builtins.readFile ./scripts/sound-levels-maintainer-flexbox.sh)
  );
in {
  home.packages = [sound-levels-maintainer];
}
