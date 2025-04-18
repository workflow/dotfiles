{pkgs, ...}:
with pkgs; [
  bitwarden
  bitwarden-cli
  cachix
  chafa # Images to terminal pixels
  discord
  gimp
  github-cli
  glab
  hicolor-icon-theme # Needed for solaar
  kubectl
  kubectx
  ledger-live-desktop
  libreoffice
  lsof
  localsend
  megacmd
  mpv # todo: persistence
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
  solaar
  sparrow
  tdesktop # Telegram
  trash-cli
  variety
  vlc
  zoom-us
]
