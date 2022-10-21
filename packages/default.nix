{ pkgs, ... }:
let
  nixpkgs-unstable = pkgs.unstable;

  nix-sysdig = pkgs.callPackage ./nix-sysdig { };
  rmview = pkgs.libsForQt5.callPackage ./rmview { };
  confluent-cli = pkgs.callPackage ./confluent-cli { };

  packages =
    [
      pkgs.android-studio
      pkgs.arandr
      pkgs.asciinema
      pkgs.audio-recorder
      nixpkgs-unstable.autotiling # autotiling script for i3
      pkgs.awscli2
      pkgs.bc
      pkgs.bind # Provides dig
      pkgs.binutils
      pkgs.bluez
      pkgs.bluez-tools
      nixpkgs-unstable.brave
      pkgs.brightnessctl
      pkgs.btop
      pkgs.cachix
      pkgs.cargo-edit
      pkgs.chafa # Images to terminal pixels
      pkgs.cntr # for Nix sandbox breakpointHook debugging
      nixpkgs-unstable.comma
      confluent-cli
      pkgs.dbeaver
      pkgs.dconf
      pkgs.deluge
      pkgs.discord
      pkgs.duplicati
      pkgs.dunst
      pkgs.efivar
      pkgs.etcher # Bootable USB stick creator
      pkgs.fd
      pkgs.feh
      pkgs.ffmpeg-full
      pkgs.file
      pkgs.fluidsynth # Midi playback
      pkgs.fortune
      pkgs.gcr # Gnome crypto stuff for gnome-keyring
      pkgs.gimp
      pkgs.github-cli
      pkgs.gmailctl
      pkgs.gomatrix # The Matrix
      pkgs.google-chrome
      pkgs.google-cloud-sdk
      pkgs.gopls # Go language server
      pkgs.gparted
      pkgs.gptfdisk # gdisk
      pkgs.gucharmap
      pkgs.hamster
      pkgs.hicolor-icon-theme # Needed for solaar
      pkgs.i3lock-pixeled
      pkgs.iftop
      pkgs.imagemagick
      pkgs.inkscape
      pkgs.insomnia
      pkgs.iw # Wifi connection strength indicator
      pkgs.jq
      pkgs.jsonnet
      pkgs.k9s
      pkgs.kbdd # XKB Daemon
      pkgs.killall
      pkgs.kind
      pkgs.kubectl
      pkgs.kubectx
      pkgs.lame
      nixpkgs-unstable.ledger-live-desktop
      pkgs.libnotify # Provides notify-send
      pkgs.libreoffice
      pkgs.lldb
      pkgs.lm_sensors
      pkgs.lsof
      pkgs.lz4 # compression
      pkgs.manix
      pkgs.megacmd
      pkgs.microplane # Make changes accross many git repos
      pkgs.minikube
      nixpkgs-unstable.mold
      pkgs.nmap
      pkgs.ncdu # Disk Space Visualization
      pkgs.neofetch
      pkgs.nethogs
      pkgs.networkmanagerapplet
      pkgs.newman
      pkgs.ngrok
      pkgs.niv
      pkgs.nix-prefetch # nix-prefetch fetchFromGitHub --owner <owner> --repo <repo> --rev <rev>
      nixpkgs-unstable.nixfmt
      nixpkgs-unstable.nixpkgs-fmt
      nixpkgs-unstable.nixpkgs-review
      pkgs.nodejs # For coc.nvim
      pkgs.nvtop
      pkgs.okular
      pkgs.onboard # On screen keyboard
      pkgs.p7zip
      pkgs.papirus-icon-theme
      pkgs.paprefs # For pasystray
      pkgs.parted
      pkgs.pasystray # Pulse Audio systray
      pkgs.patchelf
      pkgs.pavucontrol
      pkgs.pciutils
      pkgs.pdftk # PDF Manipulation Toolkit
      pkgs.playerctl
      pkgs.postgresql
      pkgs.postman
      pkgs.pstree
      pkgs.pulsemixer
      pkgs.pulumi-bin
      pkgs.pup # Streaming HTML processor/selector
      pkgs.python3
      pkgs.qalculate-gtk # Calculator
      pkgs.q-text-as-data # https://github.com/harelba/q
      pkgs.ripgrep
      rmview # Remarkable Screen Sharing
      pkgs.rnix-lsp
      pkgs.roboto
      pkgs.screenkey
      pkgs.shellcheck
      pkgs.shfmt
      nixpkgs-unstable.signal-desktop
      pkgs.skypeforlinux
      pkgs.slack
      pkgs.smartmontools
      pkgs.solaar
      pkgs.soundfont-fluid
      pkgs.python38Packages.speedtest-cli
      pkgs.spice-gtk # Needed for correct perms to forward USB to virt-manager via GTK Spice
      nixpkgs-unstable.spotify
      pkgs.stern
      pkgs.s-tui # processor monitor/stress test
      pkgs.stress
      pkgs.syncthingtray
      nix-sysdig
      nixpkgs-unstable.tdesktop # Telegram
      pkgs.tldr
      nixpkgs-unstable.todoist-electron
      pkgs.traceroute
      pkgs.trash-cli
      pkgs.tree
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
      pkgs.xawtv # Basic Video4Linux2 device viewer. Example: xawtv -c /dev/video0
      pkgs.xclip
      pkgs.xdragon # drag n drop support
      pkgs.xidlehook
      pkgs.xorg.xkill
      pkgs.xournal # PFD Annotations, useful for saving Okular annotations as well
      pkgs.xss-lock
      nixpkgs-unstable.youtube-dl
      pkgs.yq
      nixpkgs-unstable.zoom-us
    ];

in
packages
