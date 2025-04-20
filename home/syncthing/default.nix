{
  isImpermanent,
  lib,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".local/state/syncthing" # device keys and certificates
      ".config/syncthing" # pre-v1.27.0 uses this instead of $XDG_STATE_HOME above, keeping for backward-compatibility
    ];
    files = [
      ".config/syncthingtray.ini"
    ];
  };

  services.syncthing = {
    enable = false;
    tray = {
      enable = true;
      command = "syncthingtray --wait";
    };
  };

  systemd.user.services.syncthingtray = {
    # Remove existing graphical-session.target
    Install = lib.mkForce {
      WantedBy = ["sway-session.target"];
    };
  };
}
