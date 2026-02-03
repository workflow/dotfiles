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
      yubikey-touch-detector.enable = true;
      dunst.settings.yubikey_touch_detector_icon = {
        summary = "YubiKey is waiting for a touch";
        new_icon = "${pkgs.yubikey-touch-detector}/share/icons/hicolor/128x128/apps/yubikey-touch-detector.png";
      };
    };
  };
}
