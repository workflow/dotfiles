# Screen DPIs:
#
# PRISM+ @ 2560x1440: 109
# Nixbox @ 2048x1152: 168
# Nixbox @ 2560x1440: 210
{
  isHidpi,
  pkgs,
  ...
}: let
  baseHook = ''
    pkill -9 variety 2> /dev/null
    variety &>/dev/null &
  '';
  hidpiHook = ''
    ${baseHook}
      pkill -9 redshift-gtk 2> /dev/null # for applet to restart and adapt to hidpi
  '';
in {
  programs.autorandr = {
    enable = true;

    hooks = {
      postswitch = {
        background =
          if isHidpi
          then hidpiHook
          else baseHook;
        notify-i3 = "${pkgs.unstable.i3-gaps}/bin/i3-msg restart";
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
            flexbox-intel-lo-res)
              DPI=96
              ;;
            flexbox-intel-hidpi)
              DPI=192
              ;;
            flexbox-caparica)
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
            mode = "2560x1600";
            position = "0x0";
            primary = true;
          };
        };
      };

      "flexbox-intel-hidpi" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff004d10d61400000000051e0104b52517780a3510aa5333ba250c51570000000101010101010101010101010101010172e700a0f0604590302036006ee51000001828b900a0f0604590302036006ee510000018000000fe00374a584b38804c513137305231000000000002410332011200000b010a202001d202030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
        };
        config = {
          eDP-1 = {
            enable = true;
            dpi = 192;
            mode = "3840x2400";
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
            mode = "2560x1600";
            position = "0x0";
            primary = true;
          };
        };
      };

      "flexbox-intel-lo-res" = {
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
          HDMI-A-1 = "00ffffffffffff005c2d002700000000191e0103803c21780ae640ac4f44ad270c5054a54b00714f81c081809500b300d1c001010101565e00a0a0a029503020350055502100001e023a801871382d403020350029501100001e000000fd00305fdfdf3c010a202020202020000000fc005732373050524f0a2020202020019e020337724c01030405079011121314161f2309070783010000e200c0e305e301e606070160604467030c001000183c67d85dc4017880005d9300a0a0a014503020350056502100001e047600a0a0a0295030203600bc862100001e00000000000000000000000000000000000000000000000000000000000000000000000014";
          DisplayPort-1 = "00ffffffffffff004c2d7a7031574a300f200104b53c22783a6eb5ae4f46a626115054bfef8081c0810081809500a9c0b300714f01016fc200a0a0a055503020350055502100001a000000fd0032781eb732000a202020202020000000fc004c433237473578540a20202020000000ff00484e41543430303130310a2020016902031cf147903f1f041312032309070783010000e305c000e3060501565e00a0a0a029503020350055502100001a023a801871382d40582c450055502100001e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002f";
        };
        config = {
          HDMI-A-1 = {
            enable = true;
            dpi = 96;
            mode = "2560x1440";
            position = "0x0";
            primary = true;
            rate = "95.00";
          };
          DisplayPort-1 = {
            enable = true;
            dpi = 96;
            mode = "2560x1440";
            position = "2560x0";
            rate = "120.00";
          };
        };
      };

      "flexbox-caparica" = {
        fingerprint = {
          DP-2-1 = "00ffffffffffff005c2d002701000000191e0103803c21783e2d1fa6564fa0260d4f53a56b80b300a9c0950081008140818081c07140565e00a0a0a029503020350055502100001e023a801871382d40582c450055502100001e000000fd00305f1ee13c000a202020202020000000fc005732373050524f0a202020202001df020340f34c01030507049011121314161f23090707830100006a030c001000187820000067d85dc40178c000681a00000101305fede305e301e60607016060455d9300a0a0a014503020350056502100001a047600a0a0a0295030203600bc862100001a00000000000000000000000000000000000000000000000000000094";
          DP-2-3 = "00ffffffffffff004c2d797031574a300f200103803c22782a6eb5ae4f46a626115054bfef80714f810081c081809500a9c0b3000101565e00a0a0a029503020350055502100001a000000fd00324b1e5919000a202020202020000000fc004c433237473578540a20202020000000ff00484e41543430303130310a202001fd020336f149901f041303125d60612309070783010000e305c0006b030c001000983c2000200367d85dc401788001e3060501e30f8001023a801871382d40582c450055502100001e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000038";
          eDP-1 = "00ffffffffffff004d10d61400000000051e0104b52517780a3510aa5333ba250c51570000000101010101010101010101010101010172e700a0f0604590302036006ee51000001828b900a0f0604590302036006ee510000018000000fe00374a584b38804c513137305231000000000002410332011200000b010a202001d202030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
        };
        config = {
          eDP-1 = {
            enable = false;
            dpi = 96;
            mode = "1680x1050";
            position = "2560x390";
            rate = "59.95";
          };
          DP-2-1 = {
            enable = true;
            dpi = 96;
            mode = "2560x1440";
            position = "0x0";
            primary = true;
            rate = "95.00";
          };
          DP-2-3 = {
            enable = true;
            dpi = 96;
            mode = "2560x1440";
            position = "2560x0";
            primary = false;
            rate = "120.00";
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
