{
  isImpermanent,
  lib,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".local/state/syncthing" # device keys and certificates
      ".config/syncthing" # pre-v1.27.0 uses this instead of $XDG_STATE_HOME above, keeping for backward-compatibility
    ];
    files = [
      ".config/syncthingtray.ini"
    ];
  };

  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
      command = "syncthingtray --wait";
    };
  };

  systemd.user.services.syncthingtray = {
    Service = {
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
