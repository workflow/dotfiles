{
  isImpermanent,
  lib,
  pkgs,
  ...
}: {
  environment.persistence."/persist/system" = lib.mkIf isImpermanent {
    files = [
      "/etc/ly/save.ini" # Selected user and session
    ];
  };

  services.displayManager = {
    defaultSession = "niri";
    ly = {
      enable = true;
      settings = {
        animation = "doom";
        hide_borders = true;
        tty = 7; # Hopefully less logs flowing into the login screen, see https://codeberg.org/AnErrupTion/ly/issues/537
      };
    };
  };

  programs.niri.enable = true;
  # XDG Portal Settings For Niri
  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = ["wlr" "gtk"];
      };
      niri = {
        default = ["wlr" "gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
        "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    wlr.enable = true;
  };

  programs.sway = {
    enable = true;
  };
}
