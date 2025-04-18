{
  pkgs,
  inputs,
  ...
}:
(with pkgs; [
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
  pavucontrol
  pciutils
  pdftk # PDF Manipulation Toolkit
  piper # GUI for configuring Logitech mice
  playerctl
  postgresql
  pstree
  (python3.withPackages
    (ps:
      with ps; [
        json5 # For Macgyver
      ]))
  qalculate-gtk # Calculator
  q-text-as-data # https://github.com/harelba/q
  remmina
  ripdrag
  ripgrep
  rmview # Remarkable Screen Sharing
  screenkey
  scrcpy
  selectdefaultapplication # XDG Default Application Chooser
  signal-desktop
  skaffold
  slack
  smartmontools
  solaar
  sparrow
  stern
  s-tui # processor monitor/stress test
  stress
  tdesktop # Telegram
  thefuck
  traceroute
  trash-cli
  tree
  tzupdate
  unzip
  usbutils # Provides lsusb
  variety
  virt-manager
  vlc
  vnstat # Network Traffic Monitor
  wget
  wgetpaste # CLI interface to various pastebins
  wireguard-tools
  wireshark
  whois
  woeusb # Create bootable disks from Windows ISOs
  xdragon # drag n drop support
  xournal # PFD Annotations, useful for saving Okular annotations as well
  yt-dlp
  youtube-music
  yq
  zoom-us
])
++ [
  inputs.rmob.defaultPackage.x86_64-linux
]
