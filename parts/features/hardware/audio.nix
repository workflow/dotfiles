{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.nixos.audio = {
    config,
    lib,
    pkgs,
    ...
  }: {
    home-manager.users.farlion.home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".local/state/wireplumber"
        ".config/rncbc.org"
        ".config/pulse"
      ];
    };

    environment.systemPackages = with pkgs; [
      alsa-utils
      pulseaudioFull
      qpwgraph
    ];

    users.users.farlion.extraGroups = ["audio"];

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      extraConfig.pipewire."92-adjust-clock-quantum" = {
        "context.properties" = {
          "default.clock.quantum" = 2048;
          "default.clock.min-quantum" = 512;
          "default.clock.max-quantum" = 8192;
        };
      };
      extraConfig.pipewire."93-disable-autosuspend" = {
        "context.properties" = {
          "session.suspend-timeout-seconds" = 0;
        };
      };

      wireplumber.extraConfig = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = ["hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
        };

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
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".config/easyeffects"
      ];
      files = [
        ".config/pavucontrol.ini"
      ];
    };

    home.file = {
      ".config/easyeffects/irs/Razor Surround ((48k Z-Edition)) 2.Stereo +20 bass.irs".source = ./audio/_presets/irs/razor-surround-48k-z-edition-stereo-plus20-bass.irs;
      ".config/pulsemixer.cfg".source = ./audio/pulsemixer.cfg;
    };

    home.packages = [
      pkgs.pavucontrol
      pkgs.pulsemixer
    ];

    services.easyeffects = {
      enable = true;
      preset = "bass-enhancing-perfect-eq";
      extraPresets = {
        "bass-enhancing-perfect-eq" = builtins.fromJSON (builtins.readFile ./audio/_presets/output/bass-enhancing-perfect-eq.json);
      };
    };
  };
}
