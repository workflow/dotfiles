# Screen DPIs:
#
# PRISM+ @ 2560x1440: 109
# Nixbox @ 2048x1152: 168
# Nixbox @ 2560x1440: 210

{ pkgs, ... }:
let
  nixpkgs-unstable = import sources.nixpkgs-unstable { config.allowUnfree = true; };

  sources = import ../nix/sources.nix;

in
{
  programs.autorandr = {
    enable = true;

    hooks = {
      postswitch = {
        background = ''
          pkill -9 variety 2> /dev/null
          variety &>/dev/null &
        '';
        notify-i3 = "${nixpkgs-unstable.i3-gaps}/bin/i3-msg restart";
        change-dpi = ''
          case "$AUTORANDR_CURRENT_PROFILE" in
            movie)
              DPI=96
              ;;
            boar)
              DPI=96
              ;;
            single)
              DPI=96
              ;;
            flexbox)
              DPI=96
              ;;
            flexbox-intel)
              DPI=96
              ;;
            *)
              echo "Unknown profle: $AUTORANDR_CURRENT_PROFILE"
              exit 1
          esac

          echo "Xft.dpi: $DPI" | ${pkgs.xorg.xrdb}/bin/xrdb -merge
        '';
      };
    };

    profiles = {

      "flexbox" = {
        fingerprint = {
          eDP-1-1 = "00ffffffffffff004d10d61400000000051e0104b52517780a3510aa5333ba250c51570000000101010101010101010101010101010172e700a0f0604590302036006ee51000001828b900a0f0604590302036006ee510000018000000fe00374a584b38804c513137305231000000000002410332011200000b010a202001d202030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
        };
        config = {
          eDP-1-1 = {
            enable = true;
            dpi = 96;
            mode = "1920x1200";
            position = "0x0";
            primary = true;
          };
        };
      };

      "flexbox-intel" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff004d10d61400000000051e0104b52517780a3510aa5333ba250c51570000000101010101010101010101010101010172e700a0f0604590302036006ee51000001828b900a0f0604590302036006ee510000018000000fe00374a584b38804c513137305231000000000002410332011200000b010a202001d202030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
        };
        config = {
          eDP-1 = {
            enable = true;
            dpi = 96;
            mode = "1920x1200";
            position = "0x0";
            primary = true;
          };
        };
      };

      "boar" = {
        fingerprint = {
          DP-0 = "00ffffffffffff005c2d002700000000191e0104b53c21783be640ac4f44ad270c5054a54b00714f81c081809500b300d1c001010101565e00a0a0a029503020350055502100001e023a801871382d403020350029501100001e000000fd00305fdfdf3c010a202020202020000000fc005732373050524f0a20202020200137020327754c01030405079011121314161f2309070783010000e200c0e305e301e60607016060445d9300a0a0a014503020350056502100001e047600a0a0a0295030203600bc862100001e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000054";
          DP-2 = "00ffffffffffff005c2d002700000000191e0104b53c21783be640ac4f44ad270c5054a54b00714f81c081809500b300d1c001010101565e00a0a0a029503020350055502100001e023a801871382d403020350029501100001e000000fd00305fdfdf3c010a202020202020000000fc005732373050524f0a20202020200137020327754c01030405079011121314161f2309070783010000e200c0e305e301e60607016060445d9300a0a0a014503020350056502100001e047600a0a0a0295030203600bc862100001e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000054";
        };
        config = {
          DP-2 = {
            enable = true;
            dpi = 96;
            mode = "2560x1440";
            position = "0x0";
            primary = true;
            rate = "95.00";
          };
          DP-0 = {
            enable = true;
            dpi = 96;
            mode = "2560x1440";
            position = "2560x0";
            rate = "95.00";
          };
        };
      };

      "topbox-sg" = {
        fingerprint = {
          DP-2-2 = "00ffffffffffff005c2d002700000000191e0104b53c21783be640ac4f44ad270c5054a54b00714f81c081809500b300d1c001010101565e00a0a0a029503020350055502100001e023a801871382d403020350029501100001e000000fd00305fdfdf3c010a202020202020000000fc005732373050524f0a20202020200137020327754c01030405079011121314161f2309070783010000e200c0e305e301e60607016060445d9300a0a0a014503020350056502100001e047600a0a0a0295030203600bc862100001e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000054";
          eDP-1 = "00ffffffffffff0030e48b0500000000001a0104a51f1178e25715a150469d290f505400000001010101010101010101010101010101695e00a0a0a029503020a50035ae1000001a000000000000000000000000000000000000000000fe004c4720446973706c61790a2020000000fe004c503134305148322d5350423100b8";
        };
        config = {
          DP-2-2 = {
            enable = true;
            dpi = 96;
            mode = "2560x1440";
            position = "0x0";
            primary = true;
            rate = "59.95";
          };
          eDP-1 = {
            enable = false;
          };
        };
      };

      "topbox-sg-hdmi" = {
        fingerprint = {
          HDMI-1 = "00ffffffffffff005c2d002700000000191e0104b53c21783be640ac4f44ad270c5054a54b00714f81c081809500b300d1c001010101565e00a0a0a029503020350055502100001e023a801871382d403020350029501100001e000000fd00305fdfdf3c010a202020202020000000fc005732373050524f0a20202020200137020327754c01030405079011121314161f2309070783010000e200c0e305e301e60607016060445d9300a0a0a014503020350056502100001e047600a0a0a0295030203600bc862100001e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000054";
          eDP-1 = "00ffffffffffff0030e48b0500000000001a0104a51f1178e25715a150469d290f505400000001010101010101010101010101010101695e00a0a0a029503020a50035ae1000001a000000000000000000000000000000000000000000fe004c4720446973706c61790a2020000000fe004c503134305148322d5350423100b8";
        };
        config = {
          HDMI-1 = {
            enable = true;
            dpi = 96;
            mode = "2560x1440";
            position = "0x0";
            primary = true;
            rate = "59.95";
          };
          eDP-1 = {
            enable = false;
          };
        };
      };

      "single" = {
        fingerprint = {
          DP-0 = "00ffffffffffff005c2d002700000000191e0104b53c21783be640ac4f44ad270c5054a54b00714f81c081809500b300d1c001010101565e00a0a0a029503020350055502100001e023a801871382d403020350029501100001e000000fd00305fdfdf3c010a202020202020000000fc005732373050524f0a20202020200137020327754c01030405079011121314161f2309070783010000e200c0e305e301e60607016060445d9300a0a0a014503020350056502100001e047600a0a0a0295030203600bc862100001e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000054";
          DP-2 = "00ffffffffffff005c2d002700000000191e0104b53c21783be640ac4f44ad270c5054a54b00714f81c081809500b300d1c001010101565e00a0a0a029503020350055502100001e023a801871382d403020350029501100001e000000fd00305fdfdf3c010a202020202020000000fc005732373050524f0a20202020200137020327754c01030405079011121314161f2309070783010000e200c0e305e301e60607016060445d9300a0a0a014503020350056502100001e047600a0a0a0295030203600bc862100001e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000054";
        };
        config = {
          DP-2 = {
            enable = true;
            dpi = 96;
            mode = "2560x1440";
            position = "0x0";
            rate = "95.00";
            primary = true;
          };
          DP-0 = {
            enable = false;
          };
        };
      };

      "movie" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0030e48b0500000000001a0104a51f1178e25715a150469d290f505400000001010101010101010101010101010101695e00a0a0a029503020a50035ae1000001a000000000000000000000000000000000000000000fe004c4720446973706c61790a2020000000fe004c503134305148322d5350423100b8";
        };
        config = {
          eDP-1 = {
            enable = true;
            #dpi = 210;
            dpi = 96;
            mode = "2560x1440";
            position = "0x0";
            primary = true;
            rate = "60.00";
          };
        };
      };

    };

  };
}
