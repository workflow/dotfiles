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
        modules-center = ["systemd-failed-units" "group/cpu" "memory" "disk" "group/gpu"];
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

        "group/cpu" = {
          modules = [
            "cpu"
            "temperature#cpu"
            "custom/cpu-profile-toggler"
          ];
          orientation = "inherit";
        };

        cpu = {
          format = " {usage}%";
          states = {
            info = 80;
          };
          on-click = "alacritty -e btop";
          on-click-right = "alacritty -e btop";
        };

        "temperature#cpu" = {
          critical-threshold = 90;
          on-click = "alacritty -e btop";
          on-click-right = "alacritty -e btop";
          hwmon-path =
            if isNumenor
            then "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon2/temp1_input"
            else "TODO find me according to waybar docs and use coretemp-isa-0000 hwmon path";
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

        "group/gpu" = {
          modules = [
            "custom/gpu-usage"
            "temperature#gpu"
          ];
          orientation = "inherit";
        };

        "custom/gpu-usage" = {
          exec = "cat /sys/class/hwmon/hwmon1/device/gpu_busy_percent";
          format = "{}%";
          return-type = "";
          interval = 1;
          on-click = "alacritty -e nvtop";
          on-click-right = "alacritty -e nvtop";
        };

        "temperature#gpu" = {
          critical-threshold = 90;
          on-click = "alacritty -e nvtop";
          on-click-right = "alacritty -e nvtop";
          hwmon-path =
            if isNumenor
            then "/sys/devices/pci0000:00/0000:00:01.1/0000:01:00.0/0000:02:00.0/0000:03:00.0/hwmon/hwmon1/temp2_input"
            else "TODO find me according to waybar docs similar to CPU temp hwmon path";
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
        color: @base0D;
      }
      .critical {
        color: @base08;
      }
      .warning {
        color: @base0A;
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
