{ pkgs, ... }:
{
  # Disable unused outputs
  # TODO: Not working, migrate to new format on Nixos Upgrade
  environment.etc."wireplumber/wireplumber.conf.d/51-alsa-disable.conf".text = ''
    monitor.alsa.rules = [
      {
        matches = [
          {
            device.name = "alsa_card.pci-0000_01_00.1"
          }
        ]
        actions = {
          update-props = {
             device.disabled = true
          }
        }
      },
      {
        matches = [
          {
            node.name = "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__hw_sofsoundwire_5__sink.2"
          }
        ]
        actions = {
          update-props = {
             node.disabled = true
          }
        }
      },
      {
        matches = [
          {
            node.name = "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__hw_sofsoundwire_6__sink"
          }
        ]
        actions = {
          update-props = {
             node.disabled = true
          }
        }
      }
    ]
  '';

  environment.systemPackages = with pkgs; [
      alsa-utils
      pulseaudioFull
      pulsemixer
  ];

  # PipeWire!
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable sound.enable to persist the ALSA store, see https://github.com/NixOS/nixpkgs/issues/130882#issuecomment-2137339830
  sound.enable = true;
}
