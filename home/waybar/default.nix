{
  config,
  lib,
  isNvidia,
  osConfig,
  pkgs,
  ...
}: let
  dunst-dnd-waybar = pkgs.writeShellApplication {
    name = "dunst-dnd-waybar";
    runtimeInputs = [pkgs.dunst];
    text = builtins.readFile ./scripts/dunst-dnd-waybar.sh;
  };
  hostName = osConfig.networking.hostName;
  isNumenor = hostName == "numenor";
  isFlexbox = hostName == "flexbox";

  leftSection = {
    modules-left = [
      "niri/workspaces"
    ];
  };

  centerSection = {
    modules-center = [
      "systemd-failed-units"
      "group/cpu"
      "memory"
      "disk"
      "group/gpu"
      "group/network"
      "group/screens"
      "group/audio"
      "bluetooth"
      "group/power"
    ];

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
      format = " {temperatureC}°C";
      on-click = "alacritty --command btop";
      on-click-right = "alacritty --command btop";
      hwmon-path =
        if isNumenor
        then "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon2/temp1_input"
        else "/sys/devices/platform/coretemp.0/hwmon/hwmon7/temp1_input";
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
      modules =
        [
          (
            if isNvidia
            then "custom/nvidia"
            else "custom/gpu-usage"
          )
        ]
        ++ lib.optional (!isNvidia) "temperature#gpu";
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

    "custom/nvidia" = {
      exec = "nvidia-smi --query-gpu=utilization.gpu,temperature.gpu --format=csv,nounits,noheader | sed 's/\\([0-9]\\+\\), \\([0-9]\\+\\)/\\1%  \\2°C/g'";
      format = " {}";
      interval = 2;
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
      modules = ["network" "network#tailscale" "custom/macgyver" "network#mullvad" "network#wireguard"];
      orientation = "inherit";
    };

    "network" = {
      interval = 3;
      format = " ";
      format-disconnected = "  ";
      format-ethernet = " ";
      format-wifi = " ";
      format-linked = "  🚧";
      format-alt = "{bandwidthDownBytes} {bandwidthUpBytes}";
      tooltip-format = "IF:{ifname} IP:{ipaddr} NM:{netmask} {bandwidthDownBytes} {bandwidthUpBytes}";
      tooltip-format-ethernet = "IF:{ifname} IP:{ipaddr} NM:{netmask} {bandwidthDownBytes} {bandwidthUpBytes}";
      tooltip-format-wifi = "IF:{ifname} SSID:{essid} FREQ:{frequency} :{signalStrength} IP:{ipaddr} GW:{gwaddr} NM:{netmask} {bandwidthDownBytes} {bandwidthUpBytes}";
      tooltip-format-linked = "IF:{ifname} IP:{ipaddr} Connected but no internet";
      on-click-right = "alacritty --command nmtui";
    };

    "network#tailscale" = {
      interface = "tailscale0";
      interval = 3;
      format-linked = " ";
      format = " ";
      format-alt = "  {bandwidthDownBytes} {bandwidthUpBytes}";
      tooltip-format = " Tailscale IP:{ipaddr} NM:{netmask} {bandwidthDownBytes} {bandwidthUpBytes}";
      tooltip-format-linked = " Tailscale down. Right click to connect.";
      on-click-right = "tailscale up";
      on-click-middle = "tailscale down";
    };

    "custom/macgyver" = {
      exec = "macgyver-status";
      return-type = "json";
      interval = 3;
      format = "{icon}";
      format-icons = {
        up = "";
        down = "";
        error = "❌";
      };
      tooltip-format = " MacGyver is {text}";
      on-click-right = "sudo systemctl start macgyver";
      on-click-middle = "sudo systemctl stop macgyver";
    };

    "network#mullvad" = {
      interface = "wg0-mullvad";
      interval = 3;
      format-disconnected = " ";
      format-disabled = " ";
      format-linked = " ";
      format = " ";
      format-alt = "  {bandwidthDownBytes} {bandwidthUpBytes}";
      tooltip-format = "  Mullvad IP:{ipaddr} NM:{netmask} {bandwidthDownBytes} {bandwidthUpBytes}";
      tooltip-format-linked = " Mullvad down. Right click to connect or double right click for GUI.";
      tooltip-format-disabled = " Mullvad down. Rickt click to connect or double right click for GUI.";
      on-click-right = "mullvad connect";
      on-double-click-right = "mullvad-gui";
      on-click-middle = "mullvad disconnect";
    };

    "network#wireguard" = {
      interface = "wg0";
      interval = 3;
      format-disconnected = " ";
      format-disabled = " ";
      format-linked = " ";
      format = " ";
      format-alt = " {bandwidthDownBytes} {bandwidthUpBytes}";
      tooltip-format = " Wireguard IP:{ipaddr} GW:{gwaddr} NM:{netmask} {bandwidthDownBytes} {bandwidthUpBytes}";
      tooltip-format-linked = " Wireguard down.";
      tooltip-format-disabled = " Wireguard down.";
    };

    "group/screens" = {
      modules =
        if isFlexbox
        then ["backlight" "custom/wlsunset"]
        else ["custom/ddc-backlight-left" "custom/ddc-backlight-middle" "custom/ddc-backlight-right" "custom/wlsunset"];
      orientation = "inherit";
    };

    backlight = {
      format = "{icon} {percent}%";
      format-icons = ["🌑" "🌘" "🌗" "🌖" "🌕"];
    };

    "custom/ddc-backlight-left" = {
      format = "{icon} ";
      tooltip-format = "Left {percentage}%";
      format-icons = ["🌑" "🌘" "🌗" "🌖" "🌕"];
      exec = "ddc-backlight 7"; # For i2c-7
      exec-on-event = false;
      on-scroll-up = "flock /tmp/ddc_backlight.lock ddcutil setvcp 10 + 5 -b 7";
      on-scroll-down = "flock /tmp/ddc_backlight.lock ddcutil setvcp 10 - 5 -b 7";
      on-click = "kanshictl switch numenor-movie";
      on-click-middle = "wdisplays";
      on-click-right = "kanshictl switch numenor";
      return-type = "json";
      interval = 300;
    };

    "custom/ddc-backlight-middle" = {
      format = "{icon} ";
      tooltip-format = "Middle {percentage}%";
      format-icons = ["🌑" "🌘" "🌗" "🌖" "🌕"];
      exec = "ddc-backlight 8"; # For i2c-8
      exec-on-event = false;
      on-scroll-up = "flock /tmp/ddc_backlight.lock ddcutil setvcp 10 + 5 -b 8";
      on-scroll-down = "flock /tmp/ddc_backlight.lock ddcutil setvcp 10 - 5 -b 8";
      on-click = "kanshictl switch numenor-movie";
      on-click-middle = "wdisplays";
      on-click-right = "kanshictl switch numenor";
      return-type = "json";
      interval = 300;
    };

    "custom/ddc-backlight-right" = {
      format = "{icon}";
      tooltip-format = "Right {percentage}%";
      format-icons = ["🌑" "🌘" "🌗" "🌖" "🌕"];
      exec = "ddc-backlight 6"; # For i2c-6
      exec-on-event = false;
      on-scroll-up = "flock /tmp/ddc_backlight.lock ddcutil setvcp 10 + 5 -b 6";
      on-scroll-down = "flock /tmp/ddc_backlight.lock ddcutil setvcp 10 - 5 -b 6";
      on-click = "kanshictl switch numenor-movie";
      on-click-middle = "wdisplays";
      on-click-right = "kanshictl switch numenor";
      return-type = "json";
      interval = 300;
    };

    "custom/wlsunset" = {
      interval = 1;
      exec = "if pgrep wlsunset >/dev/null 2>&1; then stdbuf -oL printf '{\"alt\": \"on\",\"class\": \"on\"}'; else stdbuf -oL printf '{\"alt\": \"off\",\"class\": \"off\"}'; fi";
      on-click = "wlsunset-waybar";
      return-type = "json";
      format = " {icon}";
      tooltip-format = "wlsunset: {alt}";
      signal = 1; # SIGRTMIN+1 or 35 for updating immediately from script
      format-icons = {
        on = "";
        off = "";
      };
    };

    "group/audio" = {
      modules = [
        "pulseaudio#in"
        "pulseaudio#out"
        "mpris"
      ];
      orientation = "inherit";
    };

    "pulseaudio#in" = {
      format = "{format_source}";
      format-source = " {volume}%";
      format-source-muted = "";
      format-icons = {
        "bluez_input.DC:69:E2:9A:6E:30" = "";
        "alsa_input.usb-Apple__Inc._USB-C_to_3.5mm_Headphone_Jack_Adapter_DWH84440324JKLTA7-00.mono-fallback" = "";
        default = ["" ""];
      };
      max-volume = 200;
      scroll-step = 5;
      on-scroll-up = "pactl set-source-volume @DEFAULT_SOURCE@ +5%";
      on-scroll-down = "pactl set-source-volume @DEFAULT_SOURCE@ -5%";
      on-click = "pavucontrol --tab=4";
      on-click-right = "alacritty --command pulsemixer";
      on-click-middle = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
      tooltip-format = "{format_source}";
    };

    "pulseaudio#out" = {
      format = "{icon} {volume}%";
      format-bluetooth = "{icon} {volume}%";
      format-muted = "";
      format-icons = {
        "alsa_output.usb-Generic_USB_Audio-00.analog-stereo" = "";
        "alsa_output.usb-Lenovo_ThinkPad_Thunderbolt_3_Dock_USB_Audio_000000000000-00.analog-stereo" = "";
        "bluez_output.14_3F_A6_28_DC_51.1" = "";
        "alsa_output.pci-0000_03_00.1.hdmi-stereo-extra3" = "🍿";
        "bluez_output.DC_69_E2_9A_6E_30.1" = "";
        "bluez_sink.DC_69_E2_9A_6E_30.handsfree_head_unit" = "";
        "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0003.hw_sofsoundwire_2__sink" = "";
        "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0005.hw_sofsoundwire_2__sink" = "";
        "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0007.hw_sofsoundwire_2__sink" = "";
        "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__hw_sofsoundwire_2__sink" = "";
        "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__Speaker__sink" = "";
        "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__hw_sofsoundwire__sink" = "";
        "alsa_output.usb-Apple__Inc._USB-C_to_3.5mm_Headphone_Jack_Adapter_DWH84440324JKLTA7-00.analog-stereo" = "";
        "bluez_output.34_E3_FB_C5_01_E0.1" = "";
        "bluez_sink.34_E3_FB_C5_01_E0.handsfree_head_unit" = "";
        default = ["" ""];
      };
      max-volume = 200;
      scroll-step = 5;
      on-click = "pavucontrol --tab=3";
      on-click-right = "alacritty --command pulsemixer";
      on-click-middle = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
      ignored-sinks = ["Easy Effects Sink"];
    };

    mpris = {
      format = "{player_icon}";
      format-paused = "{status_icon}";
      on-click-right = ''niri msg action focus-window --id $(niri msg --json windows | jq -r '.[] | select(.app_id == "YouTube Music Desktop App") | .id')'';
      player-icons = {
        default = "▶";
        mpv = "";
        chromium = "";
      };
      status-icons = {
        paused = "⏸";
      };
    };

    bluetooth = {
      format = "{icon}";
      format-connected = "{icon} {num_connections}";
      format-connnected-battery = "{icon} {num_connections} {device_battery_percentage}%";
      format-icons = {
        connected = "";
        on = "";
        off = "";
        disabled = "";
        disconnected = "";
        default = "";
      };
      on-click = "bluetoothctl power on";
      on-click-right = "bluetoothctl power off";
      on-click-middle = "blueman-manager";
      tooltip-format = "{status} {num_connections}";
    };

    "group/power" = {
      modules = [
        "battery"
      ];
      orientation = "inherit";
    };

    battery = {
      states = {
        warning = 30;
        critical = 15;
      };
      format = " {icon} {capacity}%";
      format-icons = ["" "" "" "" ""];
    };
  };

  rightSection = {
    modules-right = [
      "privacy"
      "custom/dunst-dnd"
      "idle_inhibitor"
      "niri/language"
      "clock"
      "tray"
    ];

    "custom/dunst-dnd" = {
      exec = "${dunst-dnd-waybar}/bin/dunst-dnd-waybar";
      return-type = "json";
      interval = 1;
      format = "{icon}{text}";
      tooltip-format = "{text}";
      format-icons = {
        running = "";
        dnd = "";
      };
      on-click = "dunstctl set-paused toggle";
      on-click-right = "dunstctl set-paused false";
    };

    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      };
    };

    "niri/language" = {
      # TODO: https://github.com/Alexays/Waybar/issues/3657
      format = "<span color='#fabd2f'>{short}</span>";
      format-English = "us";
      on-click = "niri msg action switch-layout next";
      on-click-right = "niri msg action switch-layout prev";
      on-click-middle = "niri msg action switch-layout 0";
    };

    clock = {
      format = "{:%H:%M}";
      format-alt = "{:%A, %B %d, %Y (%R)}  ";
      tooltip-format = "<tt><small>{calendar}</small></tt>";
      calendar = {
        mode = "year";
        mode-mon-col = 3;
        weeks-pos = "right";
        on-scroll = 1;
        format = {
          months = "<span color='#ffead3'><b>{}</b></span>";
          days = "<span color='#ecc6d9'><b>{}</b></span>";
          weeks = "<span color='#99ffdd'><b>W{}</b></span>";
          weekdays = "<span color='#ffcc66'><b>{}</b></span>";
          today = "<span color='#ff6699'><b><u>{}</u></b></span>";
        };
      };
      actions = {
        on-click-right = "mode";
        on-scroll-up = "shift_up";
        on-scroll-down = "shift_down";
      };
      on-click-middle = "brave calendar.google.com";
    };

    tray = {
      show-passive-items = true;
      spacing = 3;
    };
  };
in {
  programs.waybar = {
    enable = true;
    package = pkgs.nixpkgs-waybar.waybar;
    settings = {
      main =
        {
          layer = "top";
          position = "bottom";
          expand-center = true;
          output = [
            "DP-1" # Numenor main screen
            "eDP-1" # Flexbox
          ];
        }
        // leftSection // centerSection // rightSection;

      aux =
        {
          layer = "top";
          position = "bottom";
          output = [
            "HDMI-A-1"
            "HDMI-A-2"
          ];
        }
        // leftSection // rightSection;
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

      #network.ethernet,
      #network.wifi {
        color: @base0B;
      }

      #custom-dunst-dnd.dnd {
        color: @base0A;
      }

      #custom-macgyver.up {
        color: @base0B;
      }

      #custom-wlsunset.off {
        color: @base0A;
      }

      #idle_inhibitor.activated {
        color: @base0A;
      }

      #language:not(.us) {
        color: @base0A;
      }
    '';

    systemd = {
      enable = true;
      enableDebug = false;
      enableInspect = false;
    };
  };

  systemd.user.services.waybar = {
    # Give on-click commands access to binaries they need
    Service.Environment = lib.mkForce "PATH=/run/wrappers/bin:${config.home.profileDirectory}/bin:/run/current-system/sw/bin";
    # Fix for niri startup
    Install.WantedBy = lib.mkForce ["niri.service"];
    Unit.Requires = ["niri.service"];
    Unit.After = ["niri.service"];
  };
}
