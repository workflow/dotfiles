{lib, ...}: {
  services.syncthing = {
    enable = true;
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
