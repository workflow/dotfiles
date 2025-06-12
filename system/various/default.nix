{...}: {
  services.atd.enable = true;

  boot.supportedFilesystems = ["ntfs"];

  services.tzupdate = {
    enable = true; # Oneshot systemd service, run with `sudo systemctl start tzupdate`
    timer.enable = false; # Disable automatic TZ updates
  };

  i18n.defaultLocale = "en_US.UTF-8";
}
