{
  isImpermanent,
  lib,
  pkgs,
  ...
}: let
  flameshotWithWaylandSupport = pkgs.flameshot.override {
    enableWlrSupport = true;
  };
in {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".cache/flameshot"
    ];
  };

  services.flameshot = {
    enable = true;
    package = flameshotWithWaylandSupport;
    settings = {
      General = {
        copyPathAfterSave = true;
      };
    };
  };
}
