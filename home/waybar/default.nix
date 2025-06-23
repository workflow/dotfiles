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
        modules-center = [
          "systemd-failed-units"
          "group/cpu"
          "memory"
          "disk"
          "group/gpu"
          "group/network"
        ];
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
          format = " {}%";
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

        "group/network" = {
          modules = ["network" "network#tailscale" "network#macgyver" "network#mullvad" "network#wireguard"];
          orientation = "inherit";
        };

        "network" = {
          interval = 3;
          format-disconnected = "  ";
          format-ethernet = " {bandwidthDownBytes}{bandwidthUpBytes}";
          tooltip-format-ethernet = "IF:{ifname} IP:{ipaddr} NM:{netmask}";
          format-wifi = " {bandwidthDownBytes}{bandwidthUpBytes}";
          tooltip-format-wifi = "IF:{ifname} {ssid} {frequency} {signalStrength} IP:{ipaddr} GW:{gwaddr} NM:{netwmask}";
          tooltip-format-linked = "Down. Click to connect.";
          on-click = "networkmanager_dmenu";
          on-click-right = "alacritty -e nmtui";
        };

        "network#tailscale" = {
          interface = "tailscale0";
          interval = 3;
          format-linked = " ";
          format = " {bandwidthDownBytes}{bandwidthUpBytes}";
          tooltip-format = " Tailscale IP:{ipaddr} NM:{netmask}";
          tooltip-format-linked = " down. Click to connect.";
          on-click = "tailscale up";
          on-click-right = "tailscale down";
        };

        "network#macgyver" = {
          interface = "veth0*";
          interval = 3;
          format-disconnected = " ";
          format-disabled = " ";
          format-linked = " ";
          format = " {bandwidthDownBytes}{bandwidthUpBytes}";
          tooltip-format = "  MacGyver IP:{ipaddr} NM:{netmask}";
          tooltip-format-linked = " MacGyver down. Click to connect.";
          tooltip-format-disabled = " MacGyver down. Click to connect.";
          on-click = "sudo systemctl start macgyver";
          on-click-right = "sudo systemctl stop macgyver";
        };

        "network#mullvad" = {
          interface = "wg0-mullvad";
          interval = 3;
          format-disconnected = " ";
          format-disabled = " ";
          format-linked = " ";
          format = " {bandwidthDownBytes}{bandwidthUpBytes}";
          tooltip-format = "  Mullvad IP:{ipaddr} NM:{netmask}";
          tooltip-format-linked = " Mullvad down. Click to connect or rightclick for GUI.";
          tooltip-format-disabled = " Mullvad down. Click to connect or rightclick for GUI.";
          on-click = "mullvad connect";
          on-click-right = "mullvad disconnect";
          on-click-middle = "mullvad-gui";
        };

        "network#wireguard" = {
          interface = "wg0";
          interval = 3;
          format-disconnected = " ";
          format-disabled = " ";
          format-linked = " ";
          format = " {bandwidthDownBytes}{bandwidthUpBytes}";
          tooltip-format = " Wireguard IP:{ipaddr} GW:{gwaddr} NM:{netmask}";
          tooltip-format-linked = " Wireguard down.";
          tooltip-format-disabled = " Wireguard down.";
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
