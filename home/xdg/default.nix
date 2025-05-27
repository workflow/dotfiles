{
  isImpermanent,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  isFlexbox = osConfig.networking.hostName == "flexbox";
in {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".xournal" # Other recently used files
    ];
    files = [
      ".local/share/recently-used.xbel" # Recently used files
    ];
  };

  home.packages = [
    pkgs.selectdefaultapplication # GUI XDG Default Application Chooser
  ];

  home.sessionVariables = {
    XDG_CONFIG_HOME = "/home/farlion/.config";
  };

  home.preferXdgDirectories = true;

  xdg = {
    mimeApps = {
      associations = {
        added = {
          "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        };
      };
      enable = true;
      defaultApplications = {
        "application/pdf" = ["okular.desktop"];
        "applications/x-www-browser" = ["brave-browser.desktop"];
        "image/bmp" = ["oculante.desktop"];
        "image/gif" = ["oculante.desktop"];
        "image/jpeg" = ["oculante.desktop"];
        "image/png" = ["oculante.desktop"];
        "image/svg+xml" = ["oculante.desktop"];
        "image/tiff" = ["oculante.desktop"];
        "image/webp" = ["oculante.desktop"];
        "inode/directory" = ["lf.desktop"];
        "text/html" = ["brave-browser.desktop"];
        "text/plain" = ["nvim.desktop"];
        "x-scheme-handler/about" = ["brave-browser.desktop"];
        "x-scheme-handler/http" = ["brave-browser.desktop"];
        "x-scheme-handler/https" = ["brave-browser.desktop"];
        "x-scheme-handler/mailto" = ["brave-browser.desktop"];
        "x-scheme-handler/msteams" = ["teams-for-linux.desktop"];
        "x-scheme-handler/slack" = ["slack.desktop"];
        "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
        "x-scheme-handler/tonsite" = ["org.telegram.desktop.desktop"];
        "x-scheme-handler/unknown" = ["brave-browser.desktop"];
        "x-scheme-handler/webcal" = ["brave-browser.desktop"];
      };
    };
  };
}
