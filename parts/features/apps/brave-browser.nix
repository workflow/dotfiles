{...}: {
  flake.modules.homeManager.brave-browser = {
    lib,
    pkgs,
    osConfig,
    ...
  }: let
    isNvidia = osConfig.dendrix.hasNvidia;
    # Disable VA-API video acceleration on Nvidia — causes jitter and tab crashes in Chromium
    # due to cross-GPU decode (Nvidia NVDEC) vs render (Intel iGPU) mismatch with PRIME offload.
    # Chromium 146+ enables hardware decode by default, so we also need --disable-accelerated-video-decode.
    brave =
      if isNvidia
      then
        pkgs.brave.override {
          enableVideoAcceleration = false;
          commandLineArgs = "--enable-features=${pipeWireCameraFeature}";
        }
      else withPipeWireCamera pkgs.brave;
    # Chromium's direct V4L2 path skips devices that also advertise output caps,
    # which hides the exclusive_caps=0 OBS Cam (see video.nix); PipeWire lists it.
    pipeWireCameraFeature = "WebRtcPipeWireCamera";
    # Chromium honours only the last --enable-features, so splice into the wrapper's list.
    withPipeWireCamera = pkg:
      pkg.overrideAttrs (old: let
        preFixup = builtins.replaceStrings ["--enable-features="] ["--enable-features=${pipeWireCameraFeature},"] old.preFixup;
      in
        assert preFixup != old.preFixup; {inherit preFixup;});
    # Try to focus an existing Brave window on link open so the workspace comes to the foreground
    braveNiriOpen = pkgs.writeShellApplication {
      name = "brave-niri-open";
      runtimeInputs = [pkgs.niri pkgs.jq pkgs.coreutils brave];
      text = ''
        #!/usr/bin/env bash
        set -euo pipefail
        brave_id=$(niri msg --json windows | jq -r '.[] | select(.app_id == "brave-browser") | .id' | head -n1 || true)
        if [ -n "''${brave_id:-}" ]; then
          niri msg action focus-window --id "$brave_id" >/dev/null 2>&1 || true
        fi
        exec ${brave}/bin/brave --password-store=seahorse ${
          if isNvidia
          then "--disable-accelerated-video-decode"
          else ""
        } "$@"
      '';
    };
  in {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/BraveSoftware"
        ".cache/BraveSoftware"
      ];
    };

    home.packages = [
      brave
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
