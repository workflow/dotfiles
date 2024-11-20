# Virtual inputs/outputs via Pipewire (for OBS and beyond)
{pkgs, ...}: let
  obs-mic = pkgs.writers.writeBashBin "obs-mic" (builtins.readFile ./scripts/obs-mic.sh);
in {
  home.packages = [obs-mic];

  systemd.user.services.obs-mic = {
    Unit = {
      Description = "Set up virtualMic and virtualSpeaker for OBS";
    };
    Install.WantedBy = ["default.target"];
    Service = {
      Environment = "PATH=$PATH:/run/current-system/sw/bin";
      ExecStart = "${obs-mic}/bin/obs-mic";
      Type = "oneshot";
    };
  };
}
