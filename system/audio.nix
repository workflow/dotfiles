{ lib, config, pkgs, ... }:
let
  isFlexbox = (config.networking.hostName == "flexbox");
in
{
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;

    # Writes to /etc/pulse/daemon.conf
    daemon.config = {
      default-sample-rate = 48000;
    };

    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;
  };

} // (
  lib.mkIf
    isFlexbox
    {
      boot.kernelPatches = [{
        name = "enable-soundwire-drivers";
        patch = null;
        extraConfig = ''
          CONFIG_SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES=y
          CONFIG_SND_SOC_INTEL_SOUNDWIRE_SOF_MACH=m
          CONFIG_SND_SOC_RT1308=m
        '';
      }];
    }
)
