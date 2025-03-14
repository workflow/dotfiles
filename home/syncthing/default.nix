{lib, ...}: {
  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
      command = "syncthingtray --wait";
    };
  };
  # :Hack: to wait for swaybar (the tray) to be available
  systemd.user.services.syncthingtray = {
    Install = lib.mkForce {}; # don't start automatically, trigger by timer below instead
  };
  systemd.user.timers.syncthingtray = {
    Unit = {
      Description = "Timer for Delaying the Start of Syncthing Tray";
    };
    Timer = {
      Unit = "syncthingtray.service";
      OnBootSec = "10s";
    };
    Install.WantedBy = ["sway-session.target"];
  };
}
