{ ... }:
{
  # Actively disable old pulseaudio-based sound setup
  sound.enable = false;

  # PipeWire!
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

}
