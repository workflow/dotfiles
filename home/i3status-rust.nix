# Themes and many setting looted from: https://github.com/Kthulu120/i3wm-themes/blob/master/Nature/.config/dunst/dunstrc
{
  lib,
  osConfig,
  isAmd,
  isNvidia,
  ...
}: let
  soundBlockMappings = {
    "boar" = {
      "alsa_output.pci-0000_51_00.1.hdmi-stereo-extra1" = "🔊";
      "alsa_output.pci-0000_51_00.1.hdmi-stereo" = "";
      "alsa_output.pci-0000_51_00.1.hdmi-stereo.2" = "";
      "bluez_output.14_3F_A6_28_DC_51.1" = "";
      "alsa_output.pci-0000_51_00.1.hdmi-stereo-extra3" = "🍿";
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
    }
  ];

  netBlocks =
    map
    (device: {
      block = "net";
      device = device;
      format = {
        short = "$icon $speed_down.eng(prefix:K)/$speed_up.eng(prefix:K)";
        full = "$icon{$ssid $signal_strength $frequency|} $speed_down.eng(prefix:K)/$speed_up.eng(prefix:K)";
      };
      format_alt = "$icon{$ssid $signal_strength $frequency|} {$ip|down} ^icon_net_down $speed_down.eng(prefix:K) ^icon_net_up $speed_up.eng(prefix:K)";
      click = [
        {
          button = "right";
          cmd = "alacritty -e nmtui";
        }
      ];
      missing_format = "";
    }) ["eth0" "eno1" "wlp4s0" "enp164s0u1" "enp61s0u2u1u2" "enp61s0u1u1u2" "wlp0s20f3" "enp9s0u1u1u2" "tun0" "tailscale0" "veth0"];

  hostName = osConfig.networking.hostName;
  isBoar = hostName == "boar";
  isFlexbox = hostName == "flexbox";
in {
  programs.i3status-rust = {
    enable = true;

    bars = {
      default = {
        blocks =
          [
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
                  cmd = "alacritty -e htop";
                }
              ];
            }
            {
              block = "cpu";
              interval = 1;
              format = "$icon $barchart";
              format_alt = "$icon $barchart $frequency{ $boost|}";
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
              format = "1m:$1m 5m:$5m";
              click = [
                {
                  button = "left";
                  cmd = "alacritty -e htop";
                }
                {
                  button = "right";
                  cmd = "alacritty -e btop";
                }
              ];
            }
            {
              block = "temperature";
              format = " $icon ";
              format_alt = " $icon $average avg, $max max ";
              chip = "*-isa-*";
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
              format = " ^icon_gpu $utilization $memory $temperature";
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
          ++ lib.lists.optionals isBoar [
            # {
            #   block = "custom";
            #   command = "ddc-backlight 5"; # For i2c-5
            #   format = "$icon$text";
            #   icons_overrides = {
            #     "moon_empty" = "🌑";
            #     "moon_1" = "🌘";
            #     "moon_2" = "🌗";
            #     "moon_3" = "🌖";
            #     "moon_full" = "🌕";
            #   };
            #   interval = 60;
            #   click = [
            #     {
            #       button = "up";
            #       cmd = "ddcutil setvcp 10 + 5 -b 5";
            #     }
            #     {
            #       button = "down";
            #       cmd = "ddcutil setvcp 10 - 5 -b 5";
            #     }
            #   ];
            #   json = true;
            #   merge_with_next = true;
            # }
            # {
            #   block = "custom";
            #   command = "ddc-backlight 7"; # For i2c-7
            #   format = "$icon$text";
            #   icons_overrides = {
            #     "moon_empty" = "🌑";
            #     "moon_1" = "🌘";
            #     "moon_2" = "🌗";
            #     "moon_3" = "🌖";
            #     "moon_full" = "🌕";
            #   };
            #   interval = 60;
            #   click = [
            #     {
            #       button = "up";
            #       cmd = "ddcutil setvcp 10 + 5 -b 7";
            #     }
            #     {
            #       button = "down";
            #       cmd = "ddcutil setvcp 10 - 5 -b 7";
            #     }
            #   ];
            #   json = true;
            #   merge_with_next = true;
            # }
            # {
            #   block = "custom";
            #   command = "ddc-backlight 4"; # For i2c-4
            #   format = "$icon$text";
            #   icons_overrides = {
            #     "moon_empty" = "🌑";
            #     "moon_1" = "🌘";
            #     "moon_2" = "🌗";
            #     "moon_3" = "🌖";
            #     "moon_full" = "🌕";
            #   };
            #   interval = 60;
            #   click = [
            #     {
            #       button = "up";
            #       cmd = "ddcutil setvcp 10 + 5 -b 4";
            #     }
            #     {
            #       button = "down";
            #       cmd = "ddcutil setvcp 10 - 5 -b 4";
            #     }
            #   ];
            #   json = true;
            # }
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
              driver = "kbddbus";
              format = "$layout.str(width:3)";
              click = [
                {
                  button = "left";
                  cmd = "xkb-switch --next";
                }
                {
                  button = "right";
                  cmd = "xkb-switch --next";
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
  };
}
