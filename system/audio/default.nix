{
  config,
  lib,
  pkgs,
  ...
}: let
in {
  home-manager.users.farlion.home.persistence."/persist/home/farlion" = lib.mkIf config.home-manager.extraSpecialArgs.isImpermanent {
    directories = [
      ".local/state/wireplumber" # Wireplumber state
      ".config/rncbc.org" # qpwgraph config file
      ".config/pulse" # pulseaudio cookie
    ];
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    pulseaudioFull
    qpwgraph # More extensive patchbay for Pipewire
  ];

  users.users.farlion.extraGroups = ["audio"];

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
