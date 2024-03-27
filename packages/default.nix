{ pkgs, inputs, ... }:
let
  nixpkgs-unstable = pkgs.unstable;
  aichat-13 = pkgs.callPackage ./aichat { rustPlatform = pkgs.unstable.rustPlatform; };

  packages =
    [
      aichat-13
      pkgs.appimage-run
      pkgs.arandr
      pkgs.asciinema
      pkgs.audio-recorder
      nixpkgs-unstable.autotiling # autotiling script for i3
      pkgs.awscli2
      pkgs.bc
      pkgs.bind # Provides dig
      pkgs.binutils
      pkgs.bitwarden
      pkgs.bitwarden-cli
      pkgs.bluez
      pkgs.bluez-tools
      nixpkgs-unstable.brave
      pkgs.brightnessctl
      pkgs.btop
      pkgs.cachix
      pkgs.cargo-edit
      pkgs.cargo-nextest
      pkgs.chafa # Images to terminal pixels
      pkgs.cht-sh
      pkgs.cntr # for Nix sandbox breakpointHook debugging
      nixpkgs-unstable.comma
      pkgs.dbeaver
      pkgs.dconf
      pkgs.ddcutil # For external monitor management, used by home/xsession/boar_ddc_fix.sh
      pkgs.deluge
      pkgs.delta # Syntax highlighter for git
      inputs.devenv.packages.x86_64-linux.devenv
      nixpkgs-unstable.discord
      pkgs.distrobox
      pkgs.docker-compose
      pkgs.duplicati
      pkgs.dunst
      pkgs.element-desktop
      pkgs.efivar
      pkgs.etcher # Bootable USB stick creator
      pkgs.exercism
      pkgs.fd
      pkgs.feh
      pkgs.ffmpeg-full
      pkgs.file
      pkgs.fortune
      pkgs.gcr # Gnome crypto stuff for gnome-keyring
      pkgs.gimp
      pkgs.git-crypt
      pkgs.github-cli
      pkgs.glab
      pkgs.gmailctl
      pkgs.gomatrix # The Matrix
      pkgs.google-chrome
      pkgs.google-cloud-sdk
      pkgs.gparted
      pkgs.gptfdisk # gdisk
      pkgs.gucharmap # Unicode Character Map
      pkgs.hardinfo # Hardware/System Info
      pkgs.hicolor-icon-theme # Needed for solaar
      pkgs.hplip
      pkgs.httpie
      pkgs.i3lock-pixeled
      pkgs.iftop
      pkgs.iotop-c
      pkgs.imagemagick
      pkgs.inkscape
      pkgs.iw # Wifi connection strength indicator
      nixpkgs-unstable.jetbrains.idea-ultimate
      pkgs.jq
      pkgs.jsonnet
      pkgs.k9s
      pkgs.kbdd # XKB Daemon
      pkgs.kind
      pkgs.plasma5Packages.kruler
      pkgs.kubectl
      pkgs.kubectx
      pkgs.lame
      pkgs.lazydocker
      nixpkgs-unstable.ledger-live-desktop
      pkgs.libnotify # Provides notify-send
      pkgs.libreoffice
      pkgs.lm_sensors
      pkgs.localsend
      pkgs.lsof
      pkgs.lz4 # compression
      pkgs.megacmd
      pkgs.microsoft-edge # For teams 😭
      pkgs.mpv # video player
      pkgs.gnome.nautilus
      pkgs.ncdu # Disk Space Visualization
      pkgs.nmap
      pkgs.neofetch
      pkgs.nethogs
      pkgs.networkmanagerapplet
      pkgs.nix-prefetch # nix-prefetch fetchFromGitHub --owner <owner> --repo <repo> --rev <rev>
      pkgs.nodejs # For coc.nvim
      pkgs.nvtop
      pkgs.obsidian
      pkgs.okular
      pkgs.onboard # On screen keyboard
      pkgs.openssl
      pkgs.p7zip
      pkgs.papirus-icon-theme
      pkgs.paprefs # For pasystray
      pkgs.parted
      pkgs.pasystray # Pulse Audio systray
      pkgs.patchelf
      pkgs.pavucontrol
      pkgs.pciutils
      pkgs.pdftk # PDF Manipulation Toolkit
      pkgs.piper # GUI for configuring Logitech mice
      pkgs.playerctl
      pkgs.postgresql
      pkgs.pstree
      pkgs.pulsemixer
      (pkgs.python3.withPackages
        (ps: with ps; [
          json5 # For Macgyver
        ]))
      pkgs.qalculate-gtk # Calculator
      pkgs.q-text-as-data # https://github.com/harelba/q
      nixpkgs-unstable.realvnc-vnc-viewer
      pkgs.remmina
      pkgs.ripdrag
      pkgs.ripgrep
      inputs.rmob.defaultPackage.x86_64-linux
      nixpkgs-unstable.rmview # Remarkable Screen Sharing
      pkgs.screenkey
      pkgs.scrcpy
      pkgs.selectdefaultapplication # XDG Default Application Chooser
      nixpkgs-unstable.signal-desktop
      nixpkgs-unstable.skaffold
      pkgs.slack
      pkgs.smartmontools
      pkgs.solaar
      pkgs.sparrow
      pkgs.python38Packages.speedtest-cli
      pkgs.stern
      pkgs.s-tui # processor monitor/stress test
      pkgs.stress
      pkgs.syncthingtray
      nixpkgs-unstable.tdesktop # Telegram
      pkgs.teams-for-linux # Unofficial Msft Teams App
      pkgs.thefuck
      pkgs.todoist-electron
      pkgs.traceroute
      pkgs.trash-cli
      pkgs.tree
      pkgs.trezor-suite
      pkgs.trezor-udev-rules
      pkgs.tzupdate
      pkgs.unzip
      pkgs.usbutils # Provides lsusb
      pkgs.variety
      pkgs.v4l-utils # Video4Linux2 -> configuring webcam
      pkgs.virt-manager
      pkgs.vlc
      pkgs.vnstat # Network Traffic Monitor
      pkgs.wget
      pkgs.wgetpaste # CLI interface to various pastebins
      pkgs.wireguard-tools
      pkgs.wireshark
      pkgs.whois
      pkgs.woeusb # Create bootable disks from Windows ISOs
      pkgs.xclip
      pkgs.xdg-desktop-portal
      pkgs.xdotool
      pkgs.xdragon # drag n drop support
      pkgs.xidlehook
      pkgs.xkb-switch-i3
      pkgs.xorg.xkill
      pkgs.xournal # PFD Annotations, useful for saving Okular annotations as well
      pkgs.xrandr-invert-colors
      pkgs.xss-lock
      nixpkgs-unstable.youtube-dl
      pkgs.youtube-music
      pkgs.yq
      nixpkgs-unstable.zoom-us
    ];

in
packages
