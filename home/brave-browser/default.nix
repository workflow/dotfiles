{
  lib,
  isImpermanent,
  osConfig,
  pkgs,
  ...
}: let
  isFlexbox = osConfig.networking.hostName == "flexbox";
in {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".config/BraveSoftware"
      ".cache/BraveSoftware"
    ];
  };

  home.packages = [
    pkgs.brave
  ];

  home.sessionVariables = {
    BROWSER =
      if isFlexbox
      then "brave --enable-features='VaapiVideoDecoder,VaapiVideoEncoder' --enable-raw-draw --password-store=seahorse"
      else "brave";
    DEFAULT_BROWSER =
      if isFlexbox
      then "brave --enable-features='VaapiVideoDecoder,VaapiVideoEncoder' --enable-raw-draw --password-store=seahorse"
      else "brave";
  };

  xdg.desktopEntries = {
    brave-browser = {
      exec =
        if isFlexbox
        then "${pkgs.brave}/bin/brave --enable-features=VaapiVideoDecoder,VaapiVideoEncoder --enable-raw-draw %U"
        else "${pkgs.brave}/bin/brave";
      name = "Brave Browser";
      comment = "Access the Internet";
      genericName = "Web Browser";
      categories = ["Network" "WebBrowser"];
      icon = "brave-browser";
      mimeType = ["application/pdf" "application/rdf+xml" "application/rss+xml" "application/xhtml+xml" "application/xhtml_xml" "application/xml" "image/gif" "image/jpeg" "image/png" "image/webp" "text/html" "text/xml" "x-scheme-handler/http" "x-scheme-handler/https" "x-scheme-handler/ipfs" "x-scheme-handler/ipns"];
      startupNotify = true;
      terminal = true;
      type = "Application";
    };
  };
}
