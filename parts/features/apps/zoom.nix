{...}: {
  flake.modules.homeManager.zoom = {
    osConfig,
    lib,
    pkgs,
    ...
  }: let
    isFlexbox = osConfig.dendrix.hostname == "flexbox";
  in {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      files = [
        ".config/zoom.conf"
        ".config/zoomus.conf"
      ];
      directories = [
        ".zoom"
        ".cache/zoom"
      ];
    };

    home.packages = [
      pkgs.zoom-us
    ];

    # NVIDIA screen sharing caveat: like OBS, Zoom on the NVIDIA GPU cannot
    # import Niri's Intel dmabufs, so screen sharing may break under offload.
    # Links therefore keep opening with the plain Zoom.desktop entry.
    xdg.desktopEntries = lib.mkIf isFlexbox {
      zoom-nvidia = {
        name = "Zoom Workplace (NVIDIA GPU)";
        exec = "nvidia-offload zoom %U";
        genericName = "Video Conference";
        terminal = false;
        type = "Application";
        categories = ["Network"];
        icon = "Zoom";
        startupNotify = true;
        settings.StartupWMClass = "zoom";
      };
    };

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/zoommtg" = ["Zoom.desktop"];
      "x-scheme-handler/zoomus" = ["Zoom.desktop"];
    };
  };
}
