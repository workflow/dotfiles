{...}: {
  flake.modules.nixos.display-manager = {
    config,
    lib,
    pkgs,
    ...
  }: {
    environment.persistence."/persist/system" = lib.mkIf config.dendrix.isImpermanent {
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
    # nixpkgs' niri (26.04) instead of niri-flake's stale niri-stable (25.08);
    # also matches the pkgs.niri CLI used by our helper scripts
    programs.niri.package = pkgs.niri;

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
          # gnome's AccessDialog forwards to org.gnome.Shell, absent under niri,
          # so camera portal requests (e.g. Brave) fail without ever prompting.
          "org.freedesktop.impl.portal.Access" = ["gtk"];
        };
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    # path = [] keeps NixOS's minimal default unit PATH out of the portal
    # drop-ins: GDesktopAppInfo validates bare Exec= names (zoom, slack, ...)
    # against PATH and silently drops unfindable handlers from OpenURI, which
    # broke opening zoommtg:// links. With no Environment=PATH the portals
    # inherit the full session PATH from the user manager.
    systemd.user.services.xdg-desktop-portal = {
      after = ["xdg-desktop-autostart.target"];
      path = lib.mkForce [];
    };
    systemd.user.services.xdg-desktop-portal-gtk = {
      after = ["xdg-desktop-autostart.target"];
      path = lib.mkForce [];
    };
    systemd.user.services.xdg-desktop-portal-gnome = {
      after = ["xdg-desktop-autostart.target"];
      path = lib.mkForce [];
    };
    # A single denied/dismissed Access dialog stores camera=no for all host apps
    # (app id ""), after which Brave >= 1.97 hangs enumerateDevices() and Meet
    # shows no cameras, mics or speakers. Host apps can open /dev/video* anyway,
    # so the prompt protects nothing: grant it at every login.
    systemd.user.services.portal-camera-grant = {
      description = "Grant host apps camera access in the XDG permission store";
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = lib.escapeShellArgs [
          "${pkgs.systemd}/bin/busctl"
          "--user"
          "call"
          "org.freedesktop.impl.portal.PermissionStore"
          "/org/freedesktop/impl/portal/PermissionStore"
          "org.freedesktop.impl.portal.PermissionStore"
          "SetPermission"
          "sbssas"
          "devices"
          "true"
          "camera"
          ""
          "1"
          "yes"
        ];
      };
    };

    systemd.user.services.niri-flake-polkit = {
      after = ["xdg-desktop-autostart.target"];
    };

    programs.sway.enable = true;
  };
}
