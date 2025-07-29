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
        default = ["gnome" "gtk"];
      };
      niri = {
        default = ["gnome" "gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
        "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  programs.sway = {
    enable = true;
  };
}
