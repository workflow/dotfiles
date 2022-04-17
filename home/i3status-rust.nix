# Themes and many setting looted from: https://github.com/Kthulu120/i3wm-themes/blob/master/Nature/.config/dunst/dunstrc
{ lib, config, pkgs, ... }:
let
  soundBlockMappings = {
    "boar" = {
      "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
      "alsa_output.usb-Lenovo_ThinkPad_Thunderbolt_3_Dock_USB_Audio_000000000000-00.analog-stereo" = "";
      "bluez_sink.14_3F_A6_28_DC_51.a2dp_sink" = "";
    };
    "topbox" = {
      "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
      "alsa_output.usb-Lenovo_ThinkPad_Thunderbolt_3_Dock_USB_Audio_000000000000-00.analog-stereo" = "";
      "bluez_sink.14_3F_A6_28_DC_51.a2dp_sink" = "";
    };
    "flexbox" = {
      "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0003.hw_sofsoundwire_2__sink" = "";
      "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0005.hw_sofsoundwire_2__sink" = "";
      "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi___ucm0007.hw_sofsoundwire_2__sink" = "";
      "alsa_output.pci-0000_00_1f.3-platform-sof_sdw.HiFi__hw_sofsoundwire__sink" = "";
      "alsa_output.usb-Apple__Inc._USB-C_to_3.5mm_Headphone_Jack_Adapter_DWH84440324JKLTA7-00.analog-stereo" = "";
      "bluez_sink.14_3F_A6_28_DC_51.a2dp_sink" = "";
    };
  };

  boarGPUBlocks = [
    {
      block = "nvidia_gpu";
      label = "Quadro P2000";
    }
  ];

  topboxExtraBlocks = [
    {
      block = "battery";
    }
  ];

  flexboxExtraBlocks = [
    {
      block = "battery";
    }
  ];

  # https://github.com/nix-community/home-manager/issues/393
  # TODO: Should not access the global scope here
  isBoar = sysconfig.networking.hostName == "boar";
  isTopbox = sysconfig.networking.hostName == "topbox";
  isFlexbox = sysconfig.networking.hostName == "flexbox";
  sysconfig = (import <nixpkgs/nixos> { }).config;

in
{
  programs.i3status-rust = {
    enable = true;

    bars = {
      default = {

        blocks = [
          {
            block = "disk_space";
            path = "/";
            alias = "/";
            info_type = "available";
            unit = "GB";
            interval = 60;
            warning = 20.0;
            alert = 10.0;
          }
          {
            block = "memory";
            display_type = "memory";
            format_mem = "{mem_used;G} ({mem_used_percents:1})";
            format_swap = "{swap_used_percents}%";
          }
          {
            block = "cpu";
            interval = 1;
            format = "{barchart}";
          }
          {
            block = "load";
            interval = 1;
            format = "{1m} {5m}";
          }
          {
            block = "temperature";
            collapsed = true;
            interval = 10;
            format = "{min}° min, {max}° max, {average}° avg";
            chip = "*-isa-*";
          }
        ]
        ++ lib.lists.optionals isBoar boarGPUBlocks
        ++ [
          {
            block = "networkmanager";
            ap_format = "{ssid} @ {strength}";
            on_click = "alacritty -e nmtui";
            interface_name_exclude = [ "br\\-[0-9a-f]{12}" "docker\\d+" "virbr0" ];
          }
          {
            block = "net";
            device = "eno1";
            interval = 5;
            hide_inactive = true;
            format = "{speed_down;K*b} {speed_up;K*b}";
          }
          {
            block = "net";
            device = "wlp4s0";
            format = "{speed_down;K*b} {speed_up;K*b}";
            interval = 5;
            hide_inactive = true;
          }
          {
            block = "net";
            device = "enp164s0u1";
            format = "{speed_down;K*b} {speed_up;K*b}";
            interval = 5;
            hide_inactive = true;
          }
          {
            block = "net";
            device = "enp61s0u2u1u2";
            format = "{speed_down;K*b} {speed_up;K*b}";
            interval = 5;
            hide_inactive = true;
          }
          {
            block = "net";
            device = "wlp0s20f3";
            format = "{speed_down;K*b} {speed_up;K*b}";
            interval = 5;
            hide_inactive = true;
          }
        ]
        ++ [
          {
            block = "backlight";
          }
        ]
        ++ [
          {
            block = "sound";
            driver = "pulseaudio";
            format = "{output_description} {volume}";
            on_click = "pavucontrol --tab=3";
            mappings = lib.attrsets.attrByPath [ "${sysconfig.networking.hostName}" ] { } soundBlockMappings;
            headphones_indicator = true;
          }
          {
            block = "music";
            player = "spotify";
            buttons = [ "play" "prev" "next" ];
            on_collapsed_click = "i3-msg '[class=Spotify] focus'";
            on_click = "i3-msg '[class=Spotify] focus'";
          }
          {
            block = "keyboard_layout";
            driver = "kbddbus";
          }
          {
            block = "time";
            interval = 60;
            format = "%a %d.%m %R";
          }
          {
            block = "speedtest";
            format = "{ping:1}{speed_down:3*_b;M}{speed_up:3*_b;M}";
            interval = 600; # Every Ten Minutes
          }
          {
            block = "notify";
          }
          {
            block = "pomodoro";
            notifier = "notifysend";
            notifier_path = "/run/current-system/sw/bin/notify-send";
          }
        ]
        ++ lib.lists.optionals isTopbox topboxExtraBlocks
        ++ lib.lists.optionals isFlexbox flexboxExtraBlocks
        ;

        icons = "awesome5";

        theme = "gruvbox-dark";
      };
    };

  };
}
