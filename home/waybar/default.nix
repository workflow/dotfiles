{
  config,
  lib,
  osConfig,
  isAmd,
  isNvidia,
  pkgs,
  ...
}: let
  hostName = osConfig.networking.hostName;
  isNumenor = hostName == "numenor";
  isFlexbox = hostName == "flexbox";
in {
  programs.waybar = {
    enable = true;

    settings = {
      main = {
        modules-left = ["sway/workspaces" "sway/mode"];
        modules-center = ["systemd-failed-units" "cpu" "memory" "disk" "custom/cpu-profile-toggler" "temperature"];
        expand-center = true;
        modules-right = ["idle_inhibitor" "clock" "tray"];
        position = "bottom";

        systemd-failed-units = {
          format = " {nr_failed} failed";
          format-ok = " 0";
          hide-on-ok = false;
          on-click = "alacritty -e journalctl --pager-end --catalog --boot --priority 3..3 | lnav";
          on-click-right = "alacritty -e isd";
        };

        cpu = {
          format = " {usage}%";
          states = {
            info = 80;
          };
          on-click = "alacritty -e btop";
          on-click-right = "alacritty -e btop";
        };

        memory = {
          format = " {percentage}%";
          states = {
            warning = 60;
            critical = 80;
          };
          on-click = "alacritty -e btop";
          on-click-right = "alacritty -e btop";
          tooltip-format = "{used:0.1f}GiB mem used, {swapUsed:0.1f}GiB swap used";
        };

        disk = {
          format = " {percentage_used}%";
          on-click = "alacritty -e ncdu /";
          on-click-right = "alacritty -e btop";
          states = {
            warning = 60;
            critical = 80;
          };
        };

        "custom/cpu-profile-toggler" = {
          format = "{icon}";
          format-icons = {
            performance = "";
            powersave = "";
          };
          exec = "cpu-profile-toggler";
          on-click = "auto-cpufreq-gtk";
          on-click-middle = "cpu-profile-toggler --toggle";
          on-click-right = "cpu-profile-toggler --reset";
          return-type = "json";
          interval = 5;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
      };
    };

    style = ''
      .info {
        background: @base0D;
      }
      .critical {
        background: @base08;
      }
      .warning {
        background: @base0A;
      }

      #systemd-failed-units.degraded {
        color: @base08;
      }

      #idle_inhibitor.activated {
        color: @base0A;
      }
    '';

    systemd = {
      enable = true;
      enableDebug = true;
      enableInspect = true;
      target = "sway-session.target";
    };
  };

  # Give on-click commands access to binaries they need
  systemd.user.services.waybar.Service.Environment = lib.mkForce "PATH=/run/wrappers/bin:${config.home.profileDirectory}/bin:/run/current-system/sw/bin";
}
