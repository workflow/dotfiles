{ pkgs, ... }:

let

  sources = import ../nix/sources.nix;

  nixpkgs-unstable = import sources.nixpkgs-unstable { config.allowUnfree = true; };

  #torguard = pkgs.callPackage ./torguard {};

  # TODO: Move whatever we can to home manager modules
  packages =
    [
      pkgs.arandr
      pkgs.asciinema
      pkgs.bc
      pkgs.bind # Provides dig
      pkgs.binutils
      pkgs.bluez
      pkgs.bluez-tools
      pkgs.brave
      pkgs.brightnessctl
      pkgs.dconf
      pkgs.deluge
      pkgs.duplicati
      pkgs.fd
      pkgs.feh
      pkgs.ffmpeg-full
      pkgs.file
      pkgs.fortune
      pkgs.i3lock-pixeled
      pkgs.iftop
      pkgs.inkscape
      pkgs.iw # Wifi connection strength indicator
      pkgs.jq
      pkgs.kdeApplications.kcolorchooser
      pkgs.killall
      pkgs.ksshaskpass
      pkgs.libnotify # Provides notify-send
      pkgs.lm_sensors
      pkgs.megacmd
      pkgs.ncdu
      pkgs.neofetch
      pkgs.nethogs
      pkgs.niv
      nixpkgs-unstable.nixfmt
      pkgs.nix-index # Provides nix-locate, see https://github.com/bennofs/nix-index
      pkgs.okular
      pkgs.onboard # On screen keyboard
      pkgs.patchelf
      pkgs.pavucontrol
      pkgs.pciutils
      pkgs.playerctl
      pkgs.pup
      pkgs.ripgrep
      pkgs.roboto
      nixpkgs-unstable.signal-desktop
      pkgs.slack
      pkgs.python3
      pkgs.python38Packages.speedtest-cli
      pkgs.spideroak
      nixpkgs-unstable.spotify
      nixpkgs-unstable.syncthingtray # TODO: Can be removed once https://github.com/rycee/home-manager/pull/1257 is merged
      pkgs.tdesktop # Telegram
      pkgs.terminator
      pkgs.tldr
      nixpkgs-unstable.todoist-electron
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
