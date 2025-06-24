{
  config,
  lib,
  osConfig,
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
          "group/backlight"
        ];
        expand-center = true;
        modules-right = ["idle_inhibitor" "clock" "tray"];
        position = "bottom";

        systemd-failed-units = {
          format = " {nr_failed} failed";
          format-ok = " 0";
          hide-on-ok = false;
          on-click = "alacritty --command journalctl --pager-end --catalog --boot --priority 3..3 | lnav";
          on-click-right = "alacritty --command isd";
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
          on-click = "alacritty --command btop";
          on-click-right = "alacritty --command btop";
        };

        "temperature#cpu" = {
          critical-threshold = 90;
          on-click = "alacritty --command btop";
          on-click-right = "alacritty --command btop";
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
          on-click = "alacritty --command btop";
          on-click-right = "alacritty --command btop";
          tooltip-format = "{used:0.1f}GiB mem used, {swapUsed:0.1f}GiB swap used";
        };

        disk = {
          format = " {percentage_used}%";
          on-click = "alacritty --command ncdu /";
          on-click-right = "alacritty --command btop";
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
          on-click = "alacritty --command nvtop";
          on-click-right = "alacritty --command nvtop";
        };

        "temperature#gpu" = {
          critical-threshold = 90;
          on-click = "alacritty --command nvtop";
          on-click-right = "alacritty --command nvtop";
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
          on-click-right = "alacritty --command nmtui";
        };

        "network#tailscale" = {
          interface = "tailscale0";
          interval = 3;
          format-linked = " ";
          format = " {bandwidthDownBytes}{bandwidthUpBytes}";
          tooltip-format = " Tailscale IP:{ipaddr} NM:{netmask}";
          tooltip-format-linked = " Tailscale down. Click to connect.";
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
          tooltip-format-linked = " Mullvad down. Click to connect or middleclick for GUI.";
          tooltip-format-disabled = " Mullvad down. Click to connect or middleclick for GUI.";
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

        "group/backlight" = {
          modules =
            if isFlexbox
            then ["backlight"]
            else ["custom/ddc-backlight-left" "custom/ddc-backlight-middle" "custom/ddc-backlight-right"];
          orientation = "inherit";
        };

        "custom/ddc-backlight-left" = {
          format = "{icon} ";
          tooltip-format = "Left {percentage}%";
          format-icons = ["🌑" "🌘" "🌗" "🌖" "🌕"];
          exec = "ddc-backlight 7"; # For i2c-7
          on-scroll-up = "flock /tmp/ddc_backlight.lock ddcutil setvcp 10 + 5 -b 7";
          on-scroll-down = "flock /tmp/ddc_backlight.lock ddcutil setvcp 10 - 5 -b 7";
          on-click-left = "kanshictl switch numenor-movie";
          on-click-middle = "wldisplays";
          on-click-right = "kanshictl switch numenor";
          return-type = "json";
          interval = 300;
        };

        "custom/ddc-backlight-middle" = {
          format = "{icon} ";
          tooltip-format = "Middle {percentage}%";
          format-icons = ["🌑" "🌘" "🌗" "🌖" "🌕"];
          exec = "ddc-backlight 8"; # For i2c-8
          on-scroll-up = "flock /tmp/ddc_backlight.lock ddcutil setvcp 10 + 5 -b 8";
          on-scroll-down = "flock /tmp/ddc_backlight.lock ddcutil setvcp 10 - 5 -b 8";
          on-click-left = "kanshictl switch numenor-movie";
          on-click-middle = "wldisplays";
          on-click-right = "kanshictl switch numenor";
          return-type = "json";
          interval = 300;
        };

        "custom/ddc-backlight-right" = {
          format = "{icon}";
          tooltip-format = "Right {percentage}%";
          format-icons = ["🌑" "🌘" "🌗" "🌖" "🌕"];
          exec = "ddc-backlight 6"; # For i2c-6
          on-scroll-up = "flock /tmp/ddc_backlight.lock ddcutil setvcp 10 + 5 -b 6";
          on-scroll-down = "flock /tmp/ddc_backlight.lock ddcutil setvcp 10 - 5 -b 6";
          on-click-left = "kanshictl switch numenor-movie";
          on-click-middle = "wldisplays";
          on-click-right = "kanshictl switch numenor";
          return-type = "json";
          interval = 300;
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
      enableDebug = false;
      enableInspect = false;
      target = "sway-session.target";
    };
  };

  # Give on-click commands access to binaries they need
  systemd.user.services.waybar.Service.Environment = lib.mkForce "PATH=/run/wrappers/bin:${config.home.profileDirectory}/bin:/run/current-system/sw/bin";
}
