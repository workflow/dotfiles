{ pkgs, ... }:
let
  sources = import ../nix/sources.nix;

  nixpkgs-unstable = import sources.nixpkgs-unstable { config.allowUnfree = true; };
  nixos-unstable = import sources.nixos-unstable { config.allowUnfree = true; };

  #torguard = pkgs.callPackage ./torguard {};
  ledger-live-desktop = pkgs.callPackage ./ledger-live-desktop { };
  nix-sysdig = pkgs.callPackage ./nix-sysdig { };

  variety = pkgs.callPackage ./variety { };

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
      pkgs.burpsuite
      pkgs.cachix
      pkgs.chafa # Images to terminal pixels
      pkgs.cntr # for Nix sandbox breakpointHook debugging
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
      pkgs.gparted
      pkgs.i3lock-pixeled
      pkgs.iftop
      pkgs.imagemagick
      pkgs.inkscape
      pkgs.insomnia
      pkgs.iw # Wifi connection strength indicator
      pkgs.jq
      pkgs.kdeApplications.kcolorchooser
      pkgs.killall
      pkgs.kubectx
      pkgs.lame
      ledger-live-desktop
      pkgs.libav # Provides avconv for direct video to mp3 extraction
      pkgs.libnotify # Provides notify-send
      pkgs.libreoffice
      pkgs.lm_sensors
      pkgs.lsof
      pkgs.lz4 # compression
      nixos-unstable.manix
      pkgs.megacmd
      nixpkgs-unstable.minikube
      pkgs.ncat # nmap
      pkgs.ncdu
      pkgs.neofetch
      pkgs.nethogs
      pkgs.niv
      nixpkgs-unstable.nixfmt
      nixpkgs-unstable.nixpkgs-fmt
      nixpkgs-unstable.nixpkgs-review
      pkgs.nix-index # Provides nix-locate, see https://github.com/bennofs/nix-index
      nix-sysdig
      pkgs.nodejs # For coc.nvim
      pkgs.okular
      pkgs.onboard # On screen keyboard
      pkgs.p7zip
      pkgs.parted
      pkgs.patchelf
      pkgs.pavucontrol
      pkgs.pciutils
      pkgs.playerctl
      pkgs.postgresql
      pkgs.postman
      pkgs.pstree
      pkgs.pulsemixer
      pkgs.pup # Streaming HTML processor/selector
      pkgs.python3
      pkgs.ripgrep
      pkgs.rnix-lsp
      pkgs.roboto
      nixpkgs-unstable.signal-desktop
      pkgs.skype
      pkgs.slack
      pkgs.soundfont-fluid
      pkgs.python38Packages.speedtest-cli
      nixpkgs-unstable.spotify
      pkgs.s-tui # processor monitor/stress test
      pkgs.stress
      nixpkgs-unstable.syncthingtray # TODO: Can be removed once https://github.com/rycee/home-manager/pull/1257 is merged
      pkgs.tdesktop # Telegram
      pkgs.tlaplusToolbox
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
      pkgs.wgetpaste # CLI interface to various pastebins
      pkgs.whois
      pkgs.xawtv # Basic Video4Linux2 device viewer. Example: xawtv -c /dev/video0
      pkgs.xclip
      pkgs.xidlehook
      pkgs.xorg.xkill
      pkgs.xss-lock
      nixpkgs-unstable.youtube-dl
      pkgs.yq
      nixpkgs-unstable.zoom-us
    ];

in
packages
