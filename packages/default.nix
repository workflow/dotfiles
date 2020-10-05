{ pkgs, ... }:
let
  sources = import ../nix/sources.nix;

  nixpkgs-unstable = import sources.nixpkgs-unstable { config.allowUnfree = true; };

  #torguard = pkgs.callPackage ./torguard {};
  ledger-live-desktop = pkgs.callPackage ./ledger-live-desktop { };
  nix-sysdig = pkgs.callPackage ./nix-sysdig { };

  # TODO: Move whatever we can to home manager modules
  packages =
    [
      pkgs.arandr
      pkgs.asciinema
      pkgs.audio-recorder
      pkgs.bc
      pkgs.bind # Provides dig
      pkgs.binutils
      pkgs.bluez
      pkgs.bluez-tools
      pkgs.brave
      pkgs.brightnessctl
      pkgs.cachix
      pkgs.cntr # for Nix sandbox breakpointHook debugging
      pkgs.dconf
      pkgs.deluge
      pkgs.duplicati
      pkgs.fd
      pkgs.feh
      pkgs.ffmpeg-full
      pkgs.file
      pkgs.fluidsynth # Midi playback
      pkgs.fortune
      pkgs.github-cli
      pkgs.gparted
      pkgs.i3lock-pixeled
      pkgs.iftop
      pkgs.inkscape
      pkgs.insomnia
      pkgs.iw # Wifi connection strength indicator
      pkgs.jq
      pkgs.kdeApplications.kcolorchooser
      pkgs.killall
      pkgs.ksshaskpass
      pkgs.kubectx
      pkgs.lame
      ledger-live-desktop
      pkgs.libnotify # Provides notify-send
      pkgs.lm_sensors
      pkgs.megacmd
      nixpkgs-unstable.minikube
      pkgs.ncdu
      pkgs.neofetch
      pkgs.nethogs
      pkgs.niv
      nixpkgs-unstable.nixfmt
      nixpkgs-unstable.nixpkgs-fmt
      pkgs.nix-index # Provides nix-locate, see https://github.com/bennofs/nix-index
      nix-sysdig
      pkgs.okular
      pkgs.onboard # On screen keyboard
      pkgs.patchelf
      pkgs.pavucontrol
      pkgs.pciutils
      pkgs.playerctl
      pkgs.postgresql
      pkgs.pup
      pkgs.python3
      pkgs.ripgrep
      pkgs.roboto
      nixpkgs-unstable.signal-desktop
      pkgs.slack
      pkgs.soundfont-fluid
      pkgs.python38Packages.speedtest-cli
      pkgs.spideroak
      nixpkgs-unstable.spotify
      pkgs.s-tui # processor monitor/stress test
      pkgs.stress
      nixpkgs-unstable.syncthingtray # TODO: Can be removed once https://github.com/rycee/home-manager/pull/1257 is merged
      pkgs.tdesktop # Telegram
      pkgs.terminator
      pkgs.tldr
      nixpkgs-unstable.todoist-electron
      pkgs.trash-cli
      pkgs.tree
      pkgs.unzip
      pkgs.variety
      pkgs.v4l-utils # Video4Linux2 -> configuring webcam
      pkgs.vlc
      pkgs.vnstat # Network Traffic Monitor
      nixpkgs-unstable.jetbrains.webstorm
      pkgs.wget
      pkgs.whois
      pkgs.xawtv # Basic Video4Linux2 device viewer. Example: xawtv -c /dev/video0
      pkgs.xclip
      pkgs.xidlehook
      pkgs.xorg.xkill
      pkgs.xss-lock
      pkgs.yq
      pkgs.zoom-us
    ];

in
packages
