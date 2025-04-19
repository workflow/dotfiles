{pkgs, ...}: {
  services.atd.enable = true;

  boot.tmp.cleanOnBoot = true;

  boot.supportedFilesystems = ["ntfs"];

  users = {
    users.farlion = {
      description = "Florian Peter";
      extraGroups = ["video" "disk"];
      isNormalUser = true;
      group = "users";
      shell = pkgs.fish;
    };
  };

  services.tzupdate.enable = true; # Oneshot systemd service, run with `sudo systemctl start tzupdate`
  i18n.defaultLocale = "en_US.UTF-8";

  # limit the amount of logs stored in /var/log/journal
  # writes to /etc/systemd/journald.conf
  services.journald.extraConfig = ''
    SystemMaxUse=2G
  '';

  # Default editor for root
  programs.vim = {
    defaultEditor = true;
    enable = true;
  };

  # Enable system-wide Yubikey Support
  services.udev.packages = [pkgs.yubikey-personalization];

  programs.fish.enable = true;
}
