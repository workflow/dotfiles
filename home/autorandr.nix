# Screen DPIs:
#
# PRISM+ @ 2560x1440: 109
# Nixbox @ 2048x1152: 168
# Nixbox @ 2560x1440: 210

{ pkgs, ...  }:

let

  nixpkgs-unstable = import sources.nixpkgs-unstable { config.allowUnfree = true; };

  sources = import ../nix/sources.nix;

in {
  programs.autorandr = {
    enable = true;

    hooks = {
      postswitch = {
        notify-i3 = "${nixpkgs-unstable.i3-gaps}/bin/i3-msg restart";
        #change-dpi = ''
        #  case "$AUTORANDR_CURRENT_PROFILE" in
        #    mobile)
        #      DPI=168
        #      ;;
        #    movie)
        #      DPI=210
        #      ;;
        #    sophia)
        #      DPI=109
        #      ;;
        #    *)
        #      echo "Unknown profle: $AUTORANDR_CURRENT_PROFILE"
        #      exit 1
        #  esac

        #  echo "Xft.dpi: $DPI" | ${pkgs.xorg.xrdb}/bin/xrdb -merge
        #'';
      };
    };

    profiles = {

      "mobile" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0030e48b0500000000001a0104a51f1178e25715a150469d290f505400000001010101010101010101010101010101695e00a0a0a029503020a50035ae1000001a000000000000000000000000000000000000000000fe004c4720446973706c61790a2020000000fe004c503134305148322d5350423100b8";
        };
        config = {
          eDP-1 = {
            enable = true;
            #dpi = 168;
            dpi = 96;
            mode = "2048x1152";
            position = "0x0";
            primary = true;
            rate = "59.90";
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

      "sophia" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0030e48b0500000000001a0104a51f1178e25715a150469d290f505400000001010101010101010101010101010101695e00a0a0a029503020a50035ae1000001a000000000000000000000000000000000000000000fe004c4720446973706c61790a2020000000fe004c503134305148322d5350423100b8";
          DP-2-1 = "00ffffffffffff000e98000000000000191c0103803c2278ea9055a75553a028135054bfef8081c08140818090409500a940b300d1c0565e00a0a0a029503020350055502100001a000000ff0050524938323530303233320a20000000fc00573237300a2020202020202020000000fd00384b1f591e000a202020202020017e020324f14f9005040302071601141f12131e1607230907078301000067030c001000183c023a801871382d40582c450055502100001f011d8018711c1620582c250055502100009f011d007251d01e206e28550055502100001f8c0ad08a20e02d10103e960055502100001900000000000000000000000000000000000000e2";
        };
        config = {
          eDP-1 = {
            enable = true;
            dpi = 96;
            mode = "2048x1152";
            position = "0x1440";
            rate = "59.90";
          };
          DP-2-1 = {
            enable = true;
            dpi = 96;
            mode = "2560x1440";
            position = "2048x0";
            primary = true;
            rate = "59.95";
          };
        };
      };

    };

  };
}
