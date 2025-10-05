{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".config/YouTube Music Desktop App"
    ];
  };

  home.packages = [
    pkgs.unstable.ytmdesktop
  ];

  # Override the desktop file to add --password-store flag for Last.fm integration
  # See: https://github.com/ytmdesktop/ytmdesktop/issues/1428
  xdg.desktopEntries.ytmdesktop = {
    name = "YouTube Music Desktop App";
    genericName = "Music Player";
    comment = "YouTube Music Desktop App";
    exec = "${pkgs.unstable.ytmdesktop}/bin/ytmdesktop --password-store=\"gnome-libsecret\" %U";
    icon = "ytmdesktop";
    terminal = false;
    type = "Application";
    categories = ["Audio" "AudioVideo" "Player"];
    mimeType = ["x-scheme-handler/ytmd"];
    startupNotify = true;
  };
}
