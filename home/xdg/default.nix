{pkgs, ...}: {
  home.packages = [
    pkgs.selectdefaultapplication # GUI XDG Default Application Chooser
  ];

  home.sessionVariables = {
    XDG_CONFIG_HOME = "/home/farlion/.config";
  };

  home.preferXdgDirectories = true;

  xdg = {
    desktopEntries = {
      brave-browser = {
        exec = "${pkgs.brave}/bin/brave --enable-features=\"VaapiVideoDecoder,VaapiVideoEncoder\" --enable-raw-draw %U";
        name = "Brave Browser";
        comment = "Access the Internet";
        genericName = "Web Browser";
        categories = ["Network" "WebBrowser"];
        icon = "brave-browser";
        mimeType = ["application/pdf" "application/rdf+xml" "application/rss+xml" "application/xhtml+xml" "application/xhtml_xml" "application/xml" "image/gif" "image/jpeg" "image/png" "image/webp" "text/html" "text/xml" "x-scheme-handler/http" "x-scheme-handler/https" "x-scheme-handler/ipfs" "x-scheme-handler/ipns"];
        startupNotify = true;
        type = "Application";
      };
    };

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
