{
  lib,
  isImpermanent,
  pkgs,
  ...
}: let
in {
  environment.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      "/home/farlion/.local/state/wireplumber"
    ];
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    helvum # Simple GTK patchbay for Pipewire
    pulseaudioFull
    qpwgraph # More extensive patchbay for Pipewire
  ];

  # PipeWire!
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    extraConfig.pipewire."92-adjust-max-quantum" = {
      "context.properties" = {
        "default.clock.max-quantum" = 8192; # Matches Windows Settings
      };
    };

    wireplumber.extraConfig = {
      # Enable Fancy Blueooth Codecs
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = ["hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
      };

      # Disable unused sinks and sources
      "disable-unused-nodes" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "device.nick" = "HDA NVidia";
              }
            ];
            actions = {
              update-props = {
                "device.disabled" = true;
              };
            };
          }
        ];
      };
    };
  };
}
