{pkgs, ...}: {
  imports = [
    ./modules/yubikey-touch-detector
  ];

  home.packages = with pkgs; [
    pam_u2f # U2F (via yubikey) support for PAM
    yubikey-manager # ykman
    yubioath-flutter # Yubikey management GUI
  ];

  services = {
    yubikey-touch-detector.enable = true;
  };
}
