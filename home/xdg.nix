{ pkgs, ... }:
{
  xdg = {
    desktopEntries = {
      brave-browser = {
        exec = "${pkgs.unstable.brave}/bin/brave --enable-features=\"VaapiVideoDecoder,VaapiVideoEncoder\" --enable-raw-draw %U";
        name = "Brave Browser";
        comment = "Access the Internet";
        genericName = "Web Browser";
        categories = [ "Network" "WebBrowser" ];
        icon = "brave-browser";
        mimeType = [ "application/pdf" "application/rdf+xml" "application/rss+xml" "application/xhtml+xml" "application/xhtml_xml" "application/xml" "image/gif" "image/jpeg" "image/png" "image/webp" "text/html" "text/xml" "x-scheme-handler/http" "x-scheme-handler/https" "x-scheme-handler/ipfs" "x-scheme-handler/ipns" ];
        startupNotify = true;
        type = "Application";
      };
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "brave-browser.desktop" ];
        "text/plain" = [ "nvim.desktop" ];
        "x-scheme-handler/http" = [ "brave-browser.desktop" ];
        "x-scheme-handler/https" = [ "brave-browser.desktop" ];
        "x-scheme-handler/about" = [ "brave-browser.desktop" ];
        "x-scheme-handler/unknown" = [ "brave-browser.desktop" ];
        "x-scheme-handler/webcal" = [ "brave-browser.desktop" ];
        "x-scheme-handler/mailto" = [ "brave-browser.desktop" ];
        "application/pdf" = [ "okular.desktop" ];
        "inode/directory" = [ "lf.desktop" ];
        "applications/x-www-browser" = [ "brave-browser.desktop" ];
        "x-www-browser" = [ "brave-browser.desktop" ];
      };
    };
  };
}
