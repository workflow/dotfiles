{...}: {
  flake.modules.homeManager.vikunja = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/vikunja-desktop"
      ];
    };

    home.packages = [
      pkgs.vikunja-desktop
    ];

    # The package ships no desktop entry, so provide one. The app's own
    # runtime protocol registration (app.setAsDefaultProtocolClient) fails on
    # NixOS, so the vikunja-desktop:// OAuth callback scheme is wired up here.
    xdg.desktopEntries.vikunja-desktop = {
      name = "Vikunja";
      genericName = "Todo Manager";
      comment = "Todo-app to organize your life";
      exec = "${pkgs.vikunja-desktop}/bin/vikunja-desktop %u";
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
