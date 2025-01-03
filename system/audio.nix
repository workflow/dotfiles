{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alsa-utils
    helvum # Simple GTK patchbay for Pipewire
    pulseaudioFull
    pulsemixer
    qpwgraph # More extensive patchbay for Pipewire
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
        "bluez5.roles" = ["hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
      };

      # Disable unused sinks and sources
      "disable-unused-nodes" = {
        "monitor.alsa.rules" = [
          # {
          #   matches = [
          #     {
          #       "node.nick" = "HDMI / DisplayPort 1 Output";
          #     }
          #   ];
          #   actions = {
          #     update-props = {
          #       "node.disabled" = true;
          #     };
          #   };
          # }
          # {
          #   matches = [
          #     {
          #       "node.nick" = "HDMI / DisplayPort 2 Output";
          #     }
          #   ];
          #   actions = {
          #     update-props = {
          #       "node.disabled" = true;
          #     };
          #   };
          # }
          # {
          #   matches = [
          #     {
          #       "node.nick" = "HDMI / DisplayPort 3 Output";
          #     }
          #   ];
          #   actions = {
          #     update-props = {
          #       "node.disabled" = true;
          #     };
          #   };
          # }
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
