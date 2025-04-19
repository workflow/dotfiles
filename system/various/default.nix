{...}: {
  services.atd.enable = true;

  boot.tmp.cleanOnBoot = true;

  boot.supportedFilesystems = ["ntfs"];

  services.tzupdate.enable = true; # Oneshot systemd service, run with `sudo systemctl start tzupdate`
  i18n.defaultLocale = "en_US.UTF-8";
}
