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

  systemd.user.services.sound-levels-maintainer = {
    Unit = {
      After = ["obs-mic.service"];
      Description = "Maintain input/output gain/volume levels";
      Requires = ["obs-mic.service"];
    };
    Install.WantedBy = ["obs-mic.service"];
    Service = {
      Environment = "PATH=$PATH:/run/current-system/sw/bin";
      ExecStart = "${sound-levels-maintainer}/bin/sound-levels-maintainer";
      Restart = "always";
    };
  };
}
