{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.brave-browser = {
    lib,
    pkgs,
    ...
  }: let
    isNvidia = cfg.dendrix.hasNvidia;
    braveNiriOpen = pkgs.writeShellApplication {
      name = "brave-niri-open";
      runtimeInputs = [pkgs.niri pkgs.jq pkgs.coreutils pkgs.brave];
      text = ''
        #!/usr/bin/env bash
        set -euo pipefail
        brave_id=$(niri msg --json windows | jq -r '.[] | select(.app_id == "brave-browser") | .id' | head -n1 || true)
        if [ -n "''${brave_id:-}" ]; then
          niri msg action focus-window --id "$brave_id" >/dev/null 2>&1 || true
        fi
        exec ${pkgs.brave}/bin/brave ${
          if isNvidia
          then "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder --password-store=seahorse"
          else "--password-store=seahorse"
        } "$@"
      '';
    };
  in {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".config/BraveSoftware"
        ".cache/BraveSoftware"
      ];
    };

    home.packages = [
      pkgs.brave
    ];

    xdg.desktopEntries = {
      brave-browser = {
        exec = "${braveNiriOpen}/bin/brave-niri-open %U";
        name = "Brave Browser";
        comment = "Access the Internet";
        genericName = "Web Browser";
        categories = ["Network" "WebBrowser"];
        icon = "brave-browser";
        mimeType = ["application/pdf" "application/rdf+xml" "application/rss+xml" "application/xhtml+xml" "application/xhtml_xml" "application/xml" "image/gif" "image/jpeg" "image/png" "image/webp" "text/html" "text/xml" "x-scheme-handler/http" "x-scheme-handler/https" "x-scheme-handler/ipfs" "x-scheme-handler/ipns"];
        startupNotify = true;
        terminal = false;
        type = "Application";
      };
    };
  };
}
