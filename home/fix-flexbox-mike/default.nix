# Fix ALSA not detecting microphone on XPS 9700, see https://github.com/NixOS/nixpkgs/issues/130882#issuecomment-2584286824
{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  isFlexbox = osConfig.networking.hostName == "flexbox";
in {
  systemd.user.services.fixXPS9700Mike = lib.mkIf isFlexbox {
    Unit = {
      Description = "Set rt715 ADC 24 Mux to DMIC3";
    };
    Install.WantedBy = ["pipewire.service"];
    Service = {
      ExecStart = "${pkgs.alsa-utils}/bin/amixer --card 1 set 'rt715 ADC 24 Mux' 'DMIC3'";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
