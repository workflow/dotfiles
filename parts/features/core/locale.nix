{...}: {
  flake.modules.nixos.locale = {pkgs, ...}: {
    environment.systemPackages = [pkgs.comma];

    services.atd.enable = true;

    boot.supportedFilesystems = ["ntfs"];

    services.tzupdate = {
      enable = true;
      timer.enable = false;
    };
    systemd.services.tzupdate = {
      after = ["network-online.target"];
      wants = ["network-online.target"];
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "30s";
        RestartMode = "direct";
      };
    };

    i18n.defaultLocale = "en_US.UTF-8";
  };
}
