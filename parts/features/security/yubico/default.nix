{...}: {
  flake.modules.homeManager.yubico = {pkgs, ...}: {
    imports = [
      ./_modules/yubikey-touch-detector
    ];

    home.packages = with pkgs; [
      pam_u2f # U2F (via yubikey) support for PAM
      yubikey-manager # ykman
      yubioath-flutter # Yubikey management GUI
    ];

    services = {
      yubikey-touch-detector = {
        enable = true;
        # 1.13.0 keeps a stale libnotify ReplacesID once dunst's id diverges,
        # so CloseNotification hits a dead id and the touch notification never
        # disappears (upstream #85, fixed on main in 662a8d5). Pin main until
        # the next release, then drop this override.
        package = pkgs.yubikey-touch-detector.overrideAttrs (_: {
          version = "1.13.0-unstable-2026-08-31";
          src = pkgs.fetchFromGitHub {
            owner = "max-baz";
            repo = "yubikey-touch-detector";
            rev = "e6b31829567be95165c67cf40528cef765b1cb17";
            hash = "sha256-FkjZoMwjaP/6H5r5hjVKZ69Ruz/kdVQ7P6hgcsvzF6Y=";
          };
          vendorHash = "sha256-SRLhlR8qFx+cvJtWXfInE6xm/RfV4A/zfZK20esLbro=";
        });
      };
      dunst.settings.yubikey_touch_detector_icon = {
        summary = "YubiKey is waiting for a touch";
        new_icon = "${pkgs.yubikey-touch-detector}/share/icons/hicolor/128x128/apps/yubikey-touch-detector.png";
      };
    };
  };
}
