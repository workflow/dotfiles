{...}: {
  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
      command = "syncthingtray --wait";
    };
  };

  systemd.user.services.syncthingtray = {
    Install.WantedBy = ["sway-session.target"];
  };
}
