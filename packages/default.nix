{
  pkgs,
  inputs,
  ...
}:
(with pkgs; [
  asciinema
  audio-recorder
  awscli2
  bc
  bind # Provides dig
  binutils
  bitwarden
  bitwarden-cli
  bluez
  bluez-tools
  brightnessctl
  cachix
  cargo-edit
  cargo-nextest
  chafa # Images to terminal pixels
  cht-sh
  cntr # for Nix sandbox breakpointHook debugging
  dconf
  delta # Syntax highlighter for git
  devenv
  difftastic
  discord
  distrobox
  dnstracer
  docker-compose
  dunst
  element-desktop
  efivar
  exercism
  fd
  feh
  ffmpeg-full
  file
  fortune
  gcr # Gnome crypto stuff for gnome-keyring
  gimp
  git-crypt
  github-cli
  glab
  gmailctl
  gomatrix # The Matrix
  google-chrome
  gparted
  gptfdisk # gdisk
  gucharmap # Unicode Character Map
  hardinfo # Hardware/System Info
  hicolor-icon-theme # Needed for solaar
  hplip
  httpie
  iftop
  iotop-c
  imagemagick
  inkscape
  iw # Wifi connection strength indicator
  jq
  jsonnet
  plasma5Packages.kruler
  kubectl
  kubectx
  lame
  lazydocker
  ledger-live-desktop
  libnotify # Provides notify-send
  libreoffice
  lm_sensors
  localsend
  lsof
  lz4 # compression
  megacmd
  mpv # video player
  nautilus
  ncdu # Disk Space Visualization
  nmap
  nethogs
  nix-prefetch # nix-prefetch fetchFromGitHub --owner <owner> --repo <repo> --rev <rev>
  nodejs # For coc.nvim
  obsidian
  okular
  onboard # On screen keyboard
  openssl
  p7zip
  papirus-icon-theme
  parted
  patchelf
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
