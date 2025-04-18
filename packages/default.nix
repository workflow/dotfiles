{pkgs, ...}:
with pkgs; [
  nautilus # todo: persistence
  obsidian # todo: persistence
  papirus-icon-theme # todo: move to icons module in HM
  (python3.withPackages
    (ps:
      with ps; [
        json5 # For Macgyver
      ]))
  signal-desktop
  skaffold
  tdesktop # Telegram
  trash-cli
  variety
  vlc
  zoom-us
]
