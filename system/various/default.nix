{pkgs, ...}: {
  environment.systemPackages = with pkgs; [comma];

  services.atd.enable = true;

  boot.supportedFilesystems = ["ntfs"];

  services.tzupdate = {
    enable = true; # Oneshot systemd service, run with `sudo systemctl start tzupdate`
    timer.enable = false; # Disable automatic TZ updates
  };
  # Fix tzupdate networking dependency issue
  systemd.services.tzupdate = {
    after = ["network-online.target"];
    wants = ["network-online.target"];
    serviceConfig = {
      # Add retry logic in case network is still not fully ready
      Restart = "on-failure";
      RestartSec = "30s";
      RestartMode = "direct";
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
}
