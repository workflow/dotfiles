{ pkgs, ... }:
{
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
    wireplumber.extraConfig = {
      # Enable Fancy Blueooth Codecs
      "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
      };
    };
  };

  # Enable sound.enable to persist the ALSA store, see https://github.com/NixOS/nixpkgs/issues/130882#issuecomment-2137339830
  sound.enable = true;
}
