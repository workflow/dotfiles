{ lib, config, pkgs, ... }:
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

}
