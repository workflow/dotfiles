{pkgs, ...}: {
  services.atd.enable = true;

  boot.tmp.cleanOnBoot = true;

  boot.supportedFilesystems = ["ntfs"];

  services.tzupdate.enable = true; # Oneshot systemd service, run with `sudo systemctl start tzupdate`
  i18n.defaultLocale = "en_US.UTF-8";

  # limit the amount of logs stored in /var/log/journal
  # writes to /etc/systemd/journald.conf
  services.journald.extraConfig = ''
    SystemMaxUse=2G
  '';

  # Enable system-wide Yubikey Support
  services.udev.packages = [pkgs.yubikey-personalization];
}
