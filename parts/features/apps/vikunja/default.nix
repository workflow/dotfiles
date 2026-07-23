{...}: {
  flake.modules.homeManager.vikunja = {
    osConfig,
    lib,
    pkgs,
    ...
  }: let
    vikunjaDesktopAutostart = pkgs.writeShellApplication {
      name = "vikunja-desktop-autostart";
      runtimeInputs = with pkgs; [
        curl
        coreutils
        vikunja-desktop
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
      pkgs.vikunja-desktop
      vikunjaDesktopAutostart
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
