# Maintain input gain levels
{
  pkgs,
  osConfig,
  ...
}: let
  isNumenor = osConfig.networking.hostName == "numenor";
  mic-levels-maintainer = pkgs.writers.writeBashBin "mic-levels-maintainer" (
    if isNumenor
    then (builtins.readFile ./scripts/mic-levels-maintainer-numenor.sh)
    else (builtins.readFile ./scripts/mic-levels-maintainer-flexbox.sh)
  );
in {
  home.packages = [mic-levels-maintainer];

  systemd.user.services.mic-levels-maintainer = {
    Unit = {
      After = ["obs-mic.service"];
      Description = "Maintain input gain levels";
      Requires = ["obs-mic.service"];
    };
    Install.WantedBy = ["obs-mic.service"];
    Service = {
      Environment = "PATH=$PATH:/run/current-system/sw/bin";
      ExecStart = "${mic-levels-maintainer}/bin/mic-levels-maintainer";
      Restart = "always";
    };
  };
}
