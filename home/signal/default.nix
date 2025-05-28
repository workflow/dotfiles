{
  lib,
  isImpermanent,
  pkgs,
  ...
}: let
  signal-desktop-launcher-workaround = pkgs.writeShellApplication {
    name = "signal-desktop-launcher-workaround";
    runtimeInputs = [pkgs.signal-desktop pkgs.coreutils];
    text = builtins.readFile ./scripts/signal-desktop-launcher-workaround.sh;
  };
in {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".config/Signal"
    ];
  };

  home.packages = [
    pkgs.signal-desktop
  ];

  # Workaround for "launch twice" bug under wayland, see https://github.com/signalapp/Signal-Desktop/issues/6368
  xdg.desktopEntries = {
    signal-desktop = {
      exec = "${signal-desktop-launcher-workaround}/bin/signal-desktop-launcher-workaround";
      name = "Signal";
      comment = "Private messaging from your desktop";
      categories = ["Network"];
      icon = "signal-desktop";
      mimeType = ["x-scheme-handler/sgnl" "x-scheme-handler/signalcaptcha"];
      type = "Application";
    };
  };
}
