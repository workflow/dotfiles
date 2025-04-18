{pkgs, ...}:
with pkgs; [
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
