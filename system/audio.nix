{
  config,
  lib,
  pkgs,
  ...
}: let
  isFlexbox = config.networking.hostName == "flexbox";
in {
  environment.systemPackages = with pkgs; [
    alsa-utils
    helvum # Simple GTK patchbay for Pipewire
    pulseaudioFull
    pulsemixer
    qpwgraph # More extensive patchbay for Pipewire
  ];

  # Fix ALSA not detecting microphone on XPS 9700, see https://github.com/NixOS/nixpkgs/issues/130882#issuecomment-2584286824
  systemd.services.fixXPS9700Mike = lib.mkIf isFlexbox {
    description = "Set rt715 ADC 24 Mux to DMIC3";
    wantedBy = ["multi-user.target"];
    unitConfig.RequiresMountsFor = "/var/lib/alsa";

    serviceConfig = {
      ExecStart = "${pkgs.alsa-utils}/bin/amixer --card 1 set 'rt715 ADC 24 Mux' 'DMIC3'";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

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
