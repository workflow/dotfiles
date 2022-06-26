{ pkgs, ... }:
let
  sources = import ../nix/sources.nix;

  nixpkgs-unstable = import sources.nixpkgs-unstable { config.allowUnfree = true; };
  nixpkgs-master = import sources.nixpkgs-master { config.allowUnfree = true; };
  nixos-unstable = import sources.nixos-unstable { config.allowUnfree = true; };

  nix-sysdig = pkgs.callPackage ./nix-sysdig { };
  rmview = pkgs.libsForQt5.callPackage ./rmview { };
  confluent-cli = pkgs.callPackage ./confluent-cli { };

  nightly-oxalica-rust = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
    extensions = [ "rust-src" ];
  });

  packages =
    [
      pkgs.android-studio
      pkgs.arandr
      pkgs.asciinema
      pkgs.audio-recorder
      pkgs.bc
      pkgs.bind # Provides dig
      pkgs.binutils
      pkgs.bluez
      pkgs.bluez-tools
      nixpkgs-master.brave
      pkgs.brightnessctl
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
      pkgs.element-desktop # Matrix client
      pkgs.elmPackages.elm
      pkgs.elmPackages.create-elm-app
      pkgs.elmPackages.elm-format
      pkgs.elmPackages.elm-language-server
      pkgs.elmPackages.elm-test
      pkgs.exercism
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
      nixpkgs-unstable.materialize
      pkgs.megacmd
      pkgs.minikube
      pkgs.nmap
      pkgs.ncdu # Disk Space Visualization
      pkgs.neofetch
      pkgs.nethogs
      pkgs.networkmanagerapplet
      pkgs.newman
      pkgs.niv
      pkgs.nix-prefetch # nix-prefetch fetchFromGitHub --owner <owner> --repo <repo> --rev <rev>
      nixpkgs-unstable.nixfmt
      nixpkgs-unstable.nixpkgs-fmt
      nixpkgs-unstable.nixpkgs-review
      pkgs.nixos-option # check values of nixos options and where they are being set
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
      pkgs.ripgrep
      rmview # Remarkable Screen Sharing
      pkgs.rnix-lsp
      pkgs.roboto
      nightly-oxalica-rust
      pkgs.screenkey
      pkgs.shellcheck
      nixpkgs-unstable.signal-desktop
      pkgs.skypeforlinux
      pkgs.slack
      pkgs.solaar
      pkgs.soundfont-fluid
      pkgs.python38Packages.speedtest-cli
      pkgs.spice-gtk # Needed for correct perms to forward USB to virt-manager via GTK Spice
      nixpkgs-unstable.spotify
      pkgs.stern
      pkgs.s-tui # processor monitor/stress test
      pkgs.stress
      nix-sysdig
      nixpkgs-unstable.tdesktop # Telegram
      pkgs.telepresence2
      pkgs.tlaplusToolbox
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
      nixpkgs-unstable.jetbrains.webstorm
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
