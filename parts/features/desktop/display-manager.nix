{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.nixos.display-manager = {
    lib,
    pkgs,
    ...
  }: {
    environment.persistence."/persist/system" = lib.mkIf cfg.dendrix.isImpermanent {
      files = ["/etc/ly/save.ini"];
    };

    services.displayManager = {
      defaultSession = "niri";
      ly = {
        enable = true;
        settings = {
          animation = "doom";
          hide_borders = true;
        };
      };
    };

    services.gvfs.enable = true;

    programs.niri.enable = true;

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

    programs.sway.enable = true;
  };
}
