{pkgs, ...}: let
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
}
