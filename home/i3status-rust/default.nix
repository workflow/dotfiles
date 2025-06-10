# Themes and many setting looted from: https://github.com/Kthulu120/i3wm-themes/blob/master/Nature/.config/dunst/dunstrc
{
  lib,
  osConfig,
  isAmd,
  isNvidia,
  pkgs,
  ...
}: let
  soundBlockMappings = {
    "numenor" = {
      "alsa_output.usb-Generic_USB_Audio-00.analog-stereo" = "🔊";
      "alsa_output.usb-Lenovo_ThinkPad_Thunderbolt_3_Dock_USB_Audio_000000000000-00.analog-stereo" = "";
      "bluez_output.14_3F_A6_28_DC_51.1" = "";
      "alsa_output.pci-0000_03_00.1.hdmi-stereo-extra3" = "🍿";
      "bluez_output.DC_69_E2_9A_6E_30.1" = "";
      "bluez_sink.DC_69_E2_9A_6E_30.handsfree_head_unit" = "";
      "bluez_input.DC:69:E2:9A:6E:30" = "";
      "alsa_input.usb-C-Media_Electronics_Inc._USB_PnP_Audio_Device-00.mono-fallback" = "";
      "alsa_input.usb-Generic_Blue_Microphones_LT_221104181411AD020101_111000-00.analog-stereo" = "";
    };
    "flexbox" = {
      "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0003.hw_sofsoundwire_2__sink" = "";
      "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0005.hw_sofsoundwire_2__sink" = "";
      "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0007.hw_sofsoundwire_2__sink" = "";
      "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__hw_sofsoundwire_2__sink" = "";
      "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__Speaker__sink" = "";
      "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__hw_sofsoundwire__sink" = "";
      "alsa_output.usb-Apple__Inc._USB-C_to_3.5mm_Headphone_Jack_Adapter_DWH84440324JKLTA7-00.analog-stereo" = "";
      "bluez_output.14_3F_A6_28_DC_51.1" = "";
      "bluez_output.DC_69_E2_9A_6E_30.1" = "";
      "bluez_output.34_E3_FB_C5_01_E0.1" = "";
      "bluez_sink.DC_69_E2_9A_6E_30.handsfree_head_unit" = "";
      "bluez_sink.34_E3_FB_C5_01_E0.handsfree_head_unit" = "";
      "bluez_input.DC:69:E2:9A:6E:30" = "";
      "bluez_input_internal.34_E3_FB_C5_01_E0.0" = "";
      "bluez_sink.04_21_44_B6_92_39.a2dp_sink" = "";
      "alsa_input.usb-Apple__Inc._USB-C_to_3.5mm_Headphone_Jack_Adapter_DWH84440324JKLTA7-00.mono-fallback" = "";
      "alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0003.hw_sofsoundwire_4__source" = "";
      "alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0005.hw_sofsoundwire_4__source" = "";
      "alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0007.hw_sofsoundwire_4__source" = "";
      "alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi__hw_sofsoundwire_4__source" = "";
      "alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi__Mic__source" = "";
    };
  };

  flexboxExtraBlocks = [
    {
      block = "battery";
      format = {
        full = " $percentage {$time_remaining.dur(hms:true, min_unit:m) |}";
        short = " $icon  $percentage ";
      };
    }
  ];

  minNetActivationSpeed = "1000"; # Minimum detected up/down speed in bytes to show a network connection
  netDevices =
    if isFlexbox
    then ["wlp0s20f3" "tailscale0" "veth0" "wg0"]
    else if isNumenor
    then ["enp74s0" "wlp73s0" "tailscale0" "wg0"]
    else [];
  netBlocks =
    map
    (device: {
      block = "net";
      device = device;
      format = {
        short = "$icon {$speed_down.eng(prefix:K,w:3,range:${minNetActivationSpeed}..)/$speed_up.eng(prefix:K,w:3,range:${minNetActivationSpeed}..)}";
        full = "$icon {$device.str(max_w:4)} $speed_down.eng(prefix:K,w:3,range:${minNetActivationSpeed}..)/$speed_up.eng(prefix:K,w:3,range:${minNetActivationSpeed}..)";
      };
      format_alt = "$icon {$device.str(max_w:4)} {$ssid $signal_strength $frequency |}{$ip|down} ^icon_net_down $speed_down.eng(prefix:K,w:3,range:${minNetActivationSpeed}..) ^icon_net_up $speed_up.eng(prefix:K,w:3,range:${minNetActivationSpeed}..)";
      click = [
        {
          button = "right";
          cmd = "alacritty -e nmtui";
        }
      ];
      missing_format = "";
      inactive_format = "";
      error_format = ""; # When blocks are outside of `range` they still error for some reason
      error_interval = 10; # Recheck inactive net blocks every 10 seconds
      interval = 10; # For less jumpiness with the inactive net block hiding
    })
    netDevices;

  hostName = osConfig.networking.hostName;
  isNumenor = hostName == "numenor";
  isFlexbox = hostName == "flexbox";
in {
  programs.i3status-rust = {
    enable = true;

    bars = {
      default = {
        blocks =
          [
            {
              block = "custom";
              command = "systemd-errors-and-warnings-counter";
              json = true;
              interval = 30;
              click = [
                {
                  button = "left";
                  cmd = "alacritty -e fish -c 'journalctl -ex --boot --priority 3..3 | lnav'";
                }
                {
                  button = "right";
                  cmd = "alacritty -e fish -c 'journalctl -ex --boot --priority 4..4 | lnav'";
                }
              ];
            }
            {
              block = "disk_space";
              click = [
                {
                  button = "left";
                  cmd = "alacritty -e ncdu /";
                }
              ];
            }
            {
              block = "memory";
              format = "$icon $mem_used.eng(prefix:M)($mem_used_percents.eng(w:2)) ";
              format_alt = "$icon $swap_used_percents";
              click = [
                {
                  button = "right";
                  cmd = "alacritty -e btop";
                }
              ];
            }
            {
              block = "cpu";
              interval = 1;
              format = {
                short = "$utilization";
                full = "$icon $barchart";
              };
              format_alt = {
                short = "$utilization $frequency{ $boost |}";
                full = "$icon $barchart $frequency{ $boost |}";
              };
              click = [
                {
                  button = "right";
                  cmd = "alacritty -e btop";
                }
              ];
            }
            {
              block = "custom";
              command = "cpu-profile-toggler";
              json = true;
              icons_overrides = {
                "performance" = "🐰";
                "powersave" = "🔋";
              };
              interval = 1;
              format = " $icon";
              click = [
                {
                  button = "left";
                  cmd = "auto-cpufreq-gtk";
                }
                {
                  button = "middle";
                  cmd = "cpu-profile-toggler --toggle";
                }
                {
                  button = "right";
                  cmd = "sudo auto-cpufreq --force reset";
                }
              ];
            }
            {
              block = "load";
              interval = 1;
              format = {
                full = "1:$1m 5:$5m";
                short = "$1m";
              };
              click = [
                {
                  button = "left";
                  cmd = "alacritty -e btop";
                }
                {
                  button = "right";
                  cmd = "alacritty -e btop";
                }
              ];
            }
            # CPU temperature
            {
              block = "temperature";
              chip =
                if isNumenor
                then "k10temp-pci-00c3"
                else "coretemp-isa-0000";
              format = {
                short = "$icon";
                full = "  $icon ";
              };
              format_alt = " $icon $average avg, $max max ";
              good =
                if isNumenor
                then 45
                else 20;
              idle =
                if isNumenor
                then 55
                else 45;
              info =
                if isNumenor
                then 85
                else 60;
              warning =
                if isNumenor
                then 90
                else 80;
              click = [
                {
                  button = "right";
                  cmd = "alacritty -e btop";
                }
              ];
            }
          ]
          ++ lib.lists.optionals isAmd [
            {
              block = "amd_gpu";
              click = [
                {
                  button = "right";
                  cmd = "alacritty -e fish -c 'nvtop; exec fish'";
                }
              ];
            }
          ]
          ++ lib.lists.optionals isNvidia [
            {
              block = "nvidia_gpu";
              format = {
                full = " ^icon_gpu $utilization $memory $temperature";
                short = "$utilization $temperature";
              };
              click = [
                {
                  button = "left";
                  cmd = "nvidia-settings";
                }
                {
                  button = "right";
                  cmd = "alacritty -e fish -c 'nvidia-smi; exec fish'";
                }
              ];
            }
          ]
          ++ netBlocks
          ++ [
            {
              block = "custom";
              command = "macgyver-status";
              json = true;
              icons_overrides = {
                "macgyver_up" = "";
                "macgyver_down" = "";
              };
              interval = 1;
              format = " $icon $text";
              click = [
                {
                  button = "left";
                  cmd = "sudo systemctl start macgyver";
                }
                {
                  button = "right";
                  cmd = "sudo systemctl stop macgyver";
                }
              ];
            }
          ]
          ++ [
            {
              block = "custom";
              command = "tailscale-ip";
              format = "$icon $text";
              icons_overrides = {
                "tailscale_up" = "";
                "tailscale_down" = "";
              };
              interval = 1;
              json = true;
              click = [
                {
                  button = "left";
                  cmd = "sudo tailscale up --accept-routes --accept-dns=true --ssh";
                }
                {
                  button = "right";
                  cmd = "sudo tailscale down";
                }
              ];
            }
            {
              block = "vpn";
              driver = "mullvad";
              format_connected = " $icon $flag";
              format_disconnected = " $icon";
              interval = 5;
              state_connected = "good";
            }
          ]
          ++ lib.lists.optionals isFlexbox [
            {
              block = "backlight";
              format = "$icon $brightness";
              click = [
                {
                  button = "left";
                  cmd = "arandr";
                }
                {
                  button = "right";
                  cmd = "arandr";
                }
              ];
            }
          ]
          ++ lib.lists.optionals isNumenor [
            {
              block = "custom";
              command = "ddc-backlight 6"; # For i2c-6
              format = "$icon$text";
              icons_overrides = {
                "moon_empty" = "🌑";
                "moon_1" = "🌘";
                "moon_2" = "🌗";
                "moon_3" = "🌖";
                "moon_full" = "🌕";
              };
              interval = 300;
              error_interval = 300;
              click = [
                {
                  button = "up";
                  cmd = "flock /tmp/ddc_backlight.lock ddcutil setvcp 10 + 5 -b 6";
                }
                {
                  button = "down";
                  cmd = "flock /tmp/ddc_backlight.lock ddcutil setvcp 10 - 5 -b 6";
                }
              ];
              json = true;
            }
            {
              block = "custom";
              command = "ddc-backlight 8"; # For i2c-8
              format = "$icon$text";
              icons_overrides = {
                "moon_empty" = "🌑";
                "moon_1" = "🌘";
                "moon_2" = "🌗";
                "moon_3" = "🌖";
                "moon_full" = "🌕";
              };
              interval = 300;
              error_interval = 300;
              click = [
                {
                  button = "up";
                  cmd = "flock /tmp/ddc_backlight.lock ddcutil setvcp 10 + 5 -b 8";
                }
                {
                  button = "down";
                  cmd = "flock /tmp/ddc_backlight.lock ddcutil setvcp 10 - 5 -b 8";
                }
              ];
              json = true;
              merge_with_next = true;
            }
            {
              block = "custom";
              command = "ddc-backlight 7"; # For i2c-7
              format = "$icon$text";
              icons_overrides = {
                "moon_empty" = "🌑";
                "moon_1" = "🌘";
                "moon_2" = "🌗";
                "moon_3" = "🌖";
                "moon_full" = "🌕";
              };
              interval = 300;
              error_interval = 300;
              click = [
                {
                  button = "up";
                  cmd = "flock /tmp/ddc_backlight.lock ddcutil setvcp 10 + 5 -b 7";
                }
                {
                  button = "down";
                  cmd = "flock /tmp/ddc_backlight.lock ddcutil setvcp 10 - 5 -b 7";
                }
              ];
              json = true;
            }
          ]
          ++ [
            {
              block = "sound";
              driver = "pulseaudio";
              format = "$output_name {$volume.eng(w:2) |}";
              merge_with_next = true;
              click = [
                {
                  button = "left";
                  cmd = "pavucontrol --tab=4";
                }
              ];
              device_kind = "source";
              mappings = lib.attrsets.attrByPath ["${hostName}"] {} soundBlockMappings;
              headphones_indicator = true;
            }
            {
              block = "sound";
              driver = "pulseaudio";
              format = " $output_name {$volume.eng(w:2) |}";
              click = [
                {
                  button = "left";
                  cmd = "pavucontrol --tab=3";
                }
              ];
              mappings = lib.attrsets.attrByPath ["${hostName}"] {} soundBlockMappings;
              mappings_use_regex = false;
              headphones_indicator = true;
            }
            {
              block = "keyboard_layout";
              driver = "sway";
              format = "$layout.str(width:3)";
              click = [
                {
                  button = "left";
                  cmd = "swaymsg input type:keyboard xkb_switch_layout next";
                }
                {
                  button = "right";
                  cmd = "swaymsg input type:keyboard xkb_switch_layout 0";
                }
              ];
            }
            {
              block = "time";
              format = {
                short = "$icon $timestamp.datetime(f:%R)";
                full = "$icon $timestamp.datetime()";
              };
              click = [
                {
                  button = "left";
                  cmd = "brave calendar.google.com";
                }
                {
                  button = "right";
                  cmd = "brave calendar.google.com";
                }
              ];
            }
            {
              block = "notify";
            }
            {
              block = "tea_timer";
              done_cmd = "notify-send 'Ring ring, ring ring...' && pw-play '/home/farlion/Music/Own Speech/IckbinArschratte.WAV'";
            }
            {
              block = "pomodoro";
              notify_cmd = "notify-send '{msg}'";
              blocking_cmd = false;
              format = " {$message| }";
            }
          ]
          ++ lib.lists.optionals isFlexbox flexboxExtraBlocks;

        icons = "awesome6";

        theme = "gruvbox-dark";
      };
    };

    package = pkgs.unstable.i3status-rust;
  };
}
