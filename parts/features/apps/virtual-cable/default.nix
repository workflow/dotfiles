{...}: {
  flake.modules.homeManager.virtual-cable = {pkgs, ...}: let
    obs-mic = pkgs.writers.writeBashBin "obs-mic" (builtins.readFile ./scripts/obs-mic.sh);
  in {
    home.packages = [obs-mic];

    systemd.user.services.obs-mic = {
      Unit = {
        After = ["wireplumber.service"];
        Description = "Set up virtualMic and virtualSpeaker for OBS";
        Requires = ["wireplumber.service"];
      };
      Install.WantedBy = ["wireplumber.service"];
      Service = {
        Environment = "PATH=$PATH:/run/current-system/sw/bin";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
        ExecStart = "${obs-mic}/bin/obs-mic";
        Type = "oneshot";
      };
    };
  };
}
