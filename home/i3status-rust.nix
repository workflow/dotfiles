# Themes and many setting looted from: https://github.com/Kthulu120/i3wm-themes/blob/master/Nature/.config/dunst/dunstrc
{ lib, osConfig, ... }:
let
  soundBlockMappings = {
    "boar" = {
      "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
      "alsa_output.usb-Lenovo_ThinkPad_Thunderbolt_3_Dock_USB_Audio_000000000000-00.analog-stereo" = "";
      "bluez_sink.14_3F_A6_28_DC_51.a2dp_sink" = "";
      "alsa_input.usb-C-Media_Electronics_Inc._USB_PnP_Audio_Device-00.mono-fallback" = "";
      "alsa_input.usb-Generic_Blue_Microphones_LT_221104181411AD020101_111000-00.analog-stereo" = "";
    };
    "flexbox" = {
      "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0003.hw_sofsoundwire_2__sink" = "";
      "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0005.hw_sofsoundwire_2__sink" = "";
      "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0007.hw_sofsoundwire_2__sink" = "";
      "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__hw_sofsoundwire_2__sink" = "";
      "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__hw_sofsoundwire__sink" = "";
      "alsa_output.usb-Apple__Inc._USB-C_to_3.5mm_Headphone_Jack_Adapter_DWH84440324JKLTA7-00.analog-stereo" = "";
      "bluez_sink.14_3F_A6_28_DC_51.a2dp_sink" = "";
      "bluez_sink.04_21_44_B6_92_39.a2dp_sink" = "";
      "alsa_input.usb-Apple__Inc._USB-C_to_3.5mm_Headphone_Jack_Adapter_DWH84440324JKLTA7-00.mono-fallback" = "";
      "alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0003.hw_sofsoundwire_4__source" = "";
      "alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0005.hw_sofsoundwire_4__source" = "";
      "alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0007.hw_sofsoundwire_4__source" = "";
      "alsa_input.pci-0000_00_1f.3-platform-sof_sdw.HiFi__hw_sofsoundwire_4__source" = "";
    };
  };

  boarGPUBlocks = [
    {
      block = "nvidia_gpu";
      format = " $name $utilization $memory $temperature ";
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
  ];

  flexboxExtraBlocks = [
    {
      block = "battery";
    }
  ];

  netBlocks = map
    (device: {
      block = "net";
      device = device;
      format = " $icon {$ssid $signal_strength $frequency|🚡} {$ip|down} ^icon_net_down $speed_down.eng(prefix:K) ^icon_net_up $speed_up.eng(prefix:K) ";
      click = [
        {
          button = "left";
          cmd = "alacritty -e nmtui";
        }
        {
          button = "right";
          cmd = "alacritty -e nmtui";
        }
      ];
      missing_format = "";
    }) [ "eth0" "eno1" "wlp4s0" "enp164s0u1" "enp61s0u2u1u2" "enp61s0u1u1u2" "wlp0s20f3" "enp9s0u1u1u2" "tun0" "tailscale0" "veth0" ];

  hostName = osConfig.networking.hostName;
  isBoar = hostName == "boar";
  isFlexbox = hostName == "flexbox";

in
{
  programs.i3status-rust = {
    enable = true;

    bars = {
      default = {

        blocks = [
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
            format = " $icon $mem_used.eng(prefix:M)($mem_used_percents.eng(w:2)) ";
            format_alt = "$swap_used_percents";
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
            format = "$barchart";
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
            format_alt = " $icon";
            chip = "*-isa-*";
          }
        ]
        ++ lib.lists.optionals isBoar boarGPUBlocks
        ++ netBlocks
        ++ [
          {
            block = "custom";
            command = "echo -n '🧪 ' && /home/farlion/bin/macgyver-status";
            interval = 1;
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
            command = "echo -n '🦝 ' && /home/farlion/bin/tailscale-ip";
            interval = 1;
            click = [
              {
                button = "left";
                cmd = "sudo tailscale up --accept-routes --accept-dns=true";
              }
              {
                button = "right";
                cmd = "sudo tailscale down";
              }
            ];
          }
        ]
        ++ lib.lists.optionals isFlexbox [
          {
            block = "backlight";
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
          {
            block = "backlight";
            device = "ddcci4";
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
          {
            block = "backlight";
            device = "ddcci5";
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
        ++ [
          {
            block = "sound";
            driver = "pulseaudio";
            format = "$output_name {$volume.eng(w:2) |}";
            click = [
              {
                button = "left";
                cmd = "pavucontrol --tab=4";
              }
            ];
            device_kind = "source";
            mappings = lib.attrsets.attrByPath [ "${hostName}" ] { } soundBlockMappings;
            headphones_indicator = true;
          }
          {
            block = "sound";
            driver = "pulseaudio";
            format = "$output_name {$volume.eng(w:2) |}";
            click = [
              {
                button = "left";
                cmd = "pavucontrol --tab=3";
              }
            ];
            mappings = lib.attrsets.attrByPath [ "${hostName}" ] { } soundBlockMappings;
            headphones_indicator = true;
          }
          # {
          #   block = "music";
          #   player = "spotify";
          #   buttons = [ "play" "prev" "next" ];
          #   click = [
          #     {
          #       button = "left";
          #       cmd = "i3-msg '[class=Spotify] focus'";
          #     }
          #     {
          #       button = "right";
          #       cmd = "i3-msg '[class=Spotify] focus'";
          #     }
          #   ];
          # }
          {
            block = "keyboard_layout";
            driver = "kbddbus";
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
          # {
          #   block = "speedtest";
          #   click = [
          #     {
          #       button = "left";
          #       cmd = "brave fast.com";
          #     }
          #     {
          #       button = "right";
          #       cmd = "brave fast.com";
          #     }
          #   ];
          # }
          {
            block = "notify";
          }
          {
            block = "tea_timer";
            done_cmd = "notify-send 'Ring ring, ring ring...' && pactl upload-sample '/home/farlion/Music/Own Speech/IckbinArschratte.WAV' ratte && pactl play-sample ratte";

          }
          {
            block = "pomodoro";
            notify_cmd = "notify-send '{msg}'";
            blocking_cmd = false;
          }
        ]
        ++ lib.lists.optionals isFlexbox flexboxExtraBlocks
        ;

        icons = "awesome5";

        theme = "gruvbox-dark";
      };
    };

  };
}
