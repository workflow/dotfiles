{
  lib,
  pkgs,
  ...
}: let
  flameshotWithWaylandSupport = pkgs.flameshot.override {
    enableWlrSupport = true;
  };
in {
  services.flameshot = {
    enable = true;
    package = flameshotWithWaylandSupport;
    settings = {
      General = {
        copyPathAfterSave = true;
        disabledTrayIcon = true;
      };
    };
  };

  # Fix timing issue on start
  systemd.user.services.flameshot = {
    # Remove existing graphical-session.target
    Install = lib.mkForce {
      WantedBy = ["sway-session.target"];
    };
  };
}
