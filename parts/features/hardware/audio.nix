{...}: {
  flake.modules.nixos.audio = {
    config,
    lib,
    pkgs,
    ...
  }: {
    home-manager.users.farlion.home.persistence."/persist" = lib.mkIf config.dendrix.isImpermanent {
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

      extraConfig.pipewire."92-adjust-clock-quantum" = {
        "context.properties" = {
          "default.clock.quantum" = 2048; # Larger buffers should prevent xruns
          "default.clock.min-quantum" = 512; # Larger buffers should prevent xruns
          "default.clock.max-quantum" = 8192; # Matches Windows Settings
        };
      };
      extraConfig.pipewire."93-disable-autosuspend" = {
        "context.properties" = {
          "session.suspend-timeout-seconds" = 0; # Prevent autosuspend of ALSA nodes, causing xruns and crashes
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
  };

  flake.modules.homeManager.audio = {
    lib,
    pkgs,
    osConfig,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/easyeffects"
      ];
      files = [
        ".config/pavucontrol.ini"
      ];
    };

    home.file = {
      # IRS file from the same repo above
      ".config/easyeffects/irs/Razor Surround ((48k Z-Edition)) 2.Stereo +20 bass.irs".source = ./audio/_presets/irs/razor-surround-48k-z-edition-stereo-plus20-bass.irs;
      ".config/pulsemixer.cfg".source = ./audio/pulsemixer.cfg;
    };

    home.packages = [
      pkgs.pavucontrol
      pkgs.pulsemixer
    ];

    # GUI for PipeWire effects
    services.easyeffects = {
      enable = true;
      # Preset from https://github.com/JackHack96/EasyEffects-Presets/blob/master/Bass%20Enhancing%20%2B%20Perfect%20EQ.json
      preset = "bass-enhancing-perfect-eq";
      extraPresets = {
        "bass-enhancing-perfect-eq" = builtins.fromJSON (builtins.readFile ./audio/_presets/output/bass-enhancing-perfect-eq.json);
      };
    };
  };
}
