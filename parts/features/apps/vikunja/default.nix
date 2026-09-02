{...}: {
  flake.modules.homeManager.vikunja = {
    osConfig,
    lib,
    pkgs,
    ...
  }: let
    # defer-quick-entry-window: without it, the hidden quick-entry window and
    # the main window race to spend the same single-use OAuth refresh token at
    # startup, logging the user out on every cold start. Fixed upstream in
    # v2.5.0 (https://github.com/go-vikunja/vikunja/issues/3275); drop once
    # nixpkgs ships >= 2.5.0.
    # fix-tray-icon-leak: every settings load recreated the Tray, leaking a
    # ghost StatusNotifierItem per rebuild (electron/electron#49517). Fixed
    # upstream in v2.4.0 (commit e624c8a2); drop with the patch above once
    # nixpkgs ships >= 2.5.0.
    vikunjaDesktop = pkgs.vikunja-desktop.overrideAttrs (old: {
      patches =
        (old.patches or [])
        ++ [
          ./_patches/defer-quick-entry-window.patch
          ./_patches/fix-tray-icon-leak.patch
        ];
    });

    vikunjaDesktopAutostart = pkgs.writeShellApplication {
      name = "vikunja-desktop-autostart";
      runtimeInputs = [
        pkgs.curl
        pkgs.coreutils
        vikunjaDesktop
      ];
      runtimeEnv.VIKUNJA_URL = "https://vikunja.hyena-byzantine.ts.net";
      text = builtins.readFile ./_scripts/vikunja-desktop-autostart.sh;
    };
  in {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/vikunja-desktop"
      ];
    };

    home.packages = [
      vikunjaDesktop
      vikunjaDesktopAutostart
    ];

    # The package ships no desktop entry, so provide one. The app's own
    # runtime protocol registration (app.setAsDefaultProtocolClient) fails on
    # NixOS, so the vikunja-desktop:// OAuth callback scheme is wired up here.
    xdg.desktopEntries.vikunja-desktop = {
      name = "Vikunja";
      genericName = "Todo Manager";
      comment = "Todo-app to organize your life";
      exec = "${vikunjaDesktop}/bin/vikunja-desktop %u";
      icon = "vikunja-desktop";
      terminal = false;
      type = "Application";
      categories = ["Office" "ProjectManagement"];
      mimeType = ["x-scheme-handler/vikunja-desktop"];
      startupNotify = true;
    };

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/vikunja-desktop" = ["vikunja-desktop.desktop"];
    };
  };
}
