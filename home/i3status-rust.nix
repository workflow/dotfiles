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
            format_mem = "{Mug}GB ({Mup}%)";
            format_swap = "{SUp}%";
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
            block = "networkmanager";
            ap_format = "{ssid} @ {strength}%";
            on_click = "kcmshell5 kcm_networkmanagement";
          }
        ]
        ++ lib.lists.optionals (sysconfig.networking.hostName == "boar") boarNetBlocks
        ++ lib.lists.optionals (sysconfig.networking.hostName == "topbox") topboxNetBlocks
        ++ [
          {
            block = "xrandr";
            interval = 6000; # Because running the commands causes screen lag, see https://github.com/greshake/i3status-rust/issues/668
          }
        ]
        ++ lib.lists.optionals (sysconfig.networking.hostName == "boar") boarSoundBlocks
        ++ lib.lists.optionals (sysconfig.networking.hostName == "topbox") topboxSoundBlocks
        ++ [
          {
            block = "music";
            player = "spotify";
            buttons = [ "play" "prev" "next" ];
            on_collapsed_click = "i3-msg '[class=Spotify] focus'";
          }
          #        {
          #          block = "keyboard_layout";
          #          driver = "localebus";
          #        }
          {
            block = "time";
            interval = 60;
            format = "%a %d.%m %R";
          }
          {
            block = "speedtest";
            bytes = true;
          }
        ]
        ++ lib.lists.optionals (sysconfig.networking.hostName == "topbox") topboxExtraBlocks
        ;

        icons = "awesome5";

        theme = "gruvbox-dark";
      };
    };

  };
}
