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

  # Mounting Android phone from Files
  services.gvfs.enable = true;
  services.udev.packages = [pkgs.android-udev-rules];

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
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Fix niri portals autostart order
  # See https://github.com/sodiboo/niri-flake/issues/509
  systemd.user.services.xdg-desktop-portal = {
    after = ["xdg-desktop-autostart.target"];
  };
  systemd.user.services.xdg-desktop-portal-gtk = {
    after = ["xdg-desktop-autostart.target"];
  };
  systemd.user.services.xdg-desktop-portal-gnome = {
    after = ["xdg-desktop-autostart.target"];
  };
  systemd.user.services.niri-flake-polkit = {
    after = ["xdg-desktop-autostart.target"];
  };

  programs.sway = {
    enable = true;
  };
}
