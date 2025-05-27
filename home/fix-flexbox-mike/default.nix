# Fix ALSA not detecting microphone on XPS 9700, see https://github.com/NixOS/nixpkgs/issues/130882#issuecomment-2584286824
{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  isFlexbox = osConfig.networking.hostName == "flexbox";
  xps-9700-mic-fixer = pkgs.writeShellApplication {
    name = "xps-9700-mic-fixer";
    runtimeInputs = [pkgs.alsa-utils];
    text = builtins.readFile ./scripts/xps-9700-mic-fixer.sh;
  };
in {
  systemd.user.services.fixXPS9700Mike = lib.mkIf isFlexbox {
    Unit = {
      Description = "Fix ALSA settings for internal mic on Dell XPS 9700";
    };
    Install.WantedBy = ["pipewire.service"];
    Service = {
      Environment = "PATH=$PATH:/run/current-system/sw/bin";
      ExecStart = "${xps-9700-mic-fixer}/bin/xps-9700-mic-fixer";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
