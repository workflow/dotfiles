# Themes and many setting looted from: https://github.com/Kthulu120/i3wm-themes/blob/master/Nature/.config/dunst/dunstrc
{ lib, config, pkgs, ... }:
let
  boarNetBlocks = [
    {
      block = "net";
      device = "eth0";
      speed_up = true;
      interval = 5;
    }
  ];

  boarSoundBlocks = [
    {
      block = "sound";
      format = "{output_name} {volume}%";
      on_click = "pavucontrol --tab=3";
      mappings = {
        "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
        "alsa_output.usb-Lenovo_ThinkPad_Thunderbolt_3_Dock_USB_Audio_000000000000-00.analog-stereo" = "";
        "bluez_sink.14_3F_A6_28_DC_51.a2dp_sink" = "";
      };
    }
  ];

  topboxNetBlocks = [
    {
      block = "net";
      device = "wlp4s0";
      speed_up = true;
      interval = 5;
    }
  ];

  topboxSoundBlocks = [
    {
      block = "sound";
      format = "{output_name} {volume}%";
      on_click = "pavucontrol --tab=3";
      mappings = {
        "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
        "alsa_output.usb-Lenovo_ThinkPad_Thunderbolt_3_Dock_USB_Audio_000000000000-00.analog-stereo" = "";
        "bluez_sink.14_3F_A6_28_DC_51.a2dp_sink" = "";
      };
    }
  ];

  topboxExtraBlocks = [
    {
      block = "battery";
    }
  ];

  # https://github.com/nix-community/home-manager/issues/393
  # TODO: Should not access the global scope here
  isBoar = sysconfig.networking.hostName == "boar";
  isTopbox = sysconfig.networking.hostName == "topbox";
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
          {
            block = "nvidia_gpu";
            label = "Quadro P2000";
          }
          {
            block = "networkmanager";
            ap_format = "{ssid} @ {strength}%";
            on_click = "alacritty -e nmtui";
            interface_name_exclude = [ "br\\-[0-9a-f]{12}" "docker\\d+" "virbr0" ];
          }
        ]
        ++ lib.lists.optionals isBoar boarNetBlocks
        ++ lib.lists.optionals isTopbox topboxNetBlocks
        ++ [
          {
            block = "xrandr";
            interval = 6000; # Because running the commands causes screen lag, see https://github.com/greshake/i3status-rust/issues/668
          }
        ]
        ++ lib.lists.optionals isBoar boarSoundBlocks
        ++ lib.lists.optionals isTopbox topboxSoundBlocks
        ++ [
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
            format = "{ping:1}{speed_down:3*_b;M}bit/s{speed_up:3*_b;M}bit/s";
            interval = 600; # Every Ten Minutes
          }
          {
            block = "notify";
          }
        ]
        ++ lib.lists.optionals isTopbox topboxExtraBlocks
        ;

        icons = "awesome5";

        theme = "gruvbox-dark";
      };
    };

  };
}
