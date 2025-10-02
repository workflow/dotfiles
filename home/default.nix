{
  config,
  inputs,
  isImpermanent,
  isNvidia,
  lib,
  osConfig,
  pkgs,
  secrets,
  ...
}: let
  impermanenceImports =
    [
      inputs.impermanence.homeManagerModules.impermanence
    ]
    ++ lib.optionals isImpermanent [
      ./impermanence
    ];

  imports =
    [
      ./aichat
      ./alacritty
      ./aliases
      ./aws
      ./bash
      ./bitwarden
      ./bluetuith # Bluetooth TUI
      ./brave-browser
      ./broot
      ./btop
      ./calibre # Ebook reader
      ./cliphist
      ./cpu-profile-toggler
      ./devenv # devenv.sh
      ./direnv
      ./discord
      ./dunst
      ./easyeffects # GUI for Pipewire effects
      ./email
      ./firefox
      ./fish
      ./fix-flexbox-mike # Fix ALSA not detecting microphone on XPS 9700
      ./satty # Screenshot Annotation tool written in Rust
      ./fuzzel
      ./fzf
      ./galaxy-buds-client
      ./gimp
      ./git
      ./gnome-connections # RDP/VNC Client for Wayland
      ./gtk-qt
      ./isd # Interactive Systemd TUI in Python
      ./k9s
      ./kanshi # Wayland autorandr
      ./kind-with-local-registry
      ./kubernetes-tools
      ./less
      ./lf
      ./libation # Audible liberator
      ./libreoffice
      ./localsend
      ./lnav # Log File Navigator
      ./mic-levels-maintainer
      ./mpv # Media Player
      ./nautilus # Gnome File Manager
      ./neovim
      ./networkmanager-dmenu
      ./nh # https://github.com/nix-community/nh
      ./niri
      ./nix-index
      ./nushell
      ./obs # OBS Studio
      ./obsidian
      ./onboard # Virtual Keyboard for layout visualization (no good Wayland options work)
      ./pavucontrol # Pulse Audio Volume Control GUI
      ./pomodoro-gtk
      ./portfolio-performance
      ./psql # Postgresql Client with nicer config
      ./pulsemixer # TUI (curses) mixer for pulseaudio, still useful under pipewire
      ./qalculate # Calculator
      ./ripgrep
      ./ripgrep-all # Like rg, but also search in Office documents, PDFs etc...
      ./rofimoji
      ./showmethekey # screenkey for Wayland, show key presses
      ./signal
      ./solaar # Linux devices manager for the Logitech Unifying Receiver
      ./sound-switcher
      ./ssh
      ./starship
      ./stylix
      ./syncthing
      ./systemd-errors-and-warnings-counter
      ./tealdeer
      ./telegram
      ./thefuck
      ./todoist # Official Todoist app
      ./trash-cli
      ./udiskie
      ./urxvt
      ./variety # Wallpaper Switcher/Randomizer with Quotes
      ./virtual-cable # Virtual inputs/outputs via Pipewire (for OBS and beyond)
      ./vlc
      ./waybar
      ./wlsunset # Day/night gamma adjustments for Wayland
      ./xdg
      ./ytmdesktop # Youtube Music Desktop (unofficial)
      ./yubico # Yubikeys
      ./zen
      ./zoom
      ./zoxide
    ]
    ++ impermanenceImports
    ++ numenorImports
    ++ [homeManagerSecrets];

  isFlexbox = osConfig.networking.hostName == "flexbox";
  isNumenor = osConfig.networking.hostName == "numenor";

  homeManagerSecrets =
    if secrets ? homeManagerSecrets
    then secrets.homeManagerSecrets {inherit isImpermanent lib pkgs;}
    else {};

  numenorImports = lib.optionals isNumenor [
    ./ddc-backlight
  ];
in {
  home = {
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion =
      if isFlexbox
      then "22.05"
      else if isNumenor
      then "24.11"
      else "24.11";

    file."nixos-config" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config";
      target = "nixos-config";
    };

    packages = with pkgs; [
      alejandra # Nix Formatter
      ast-grep # Pure Magic
      asciinema # Terminal recording fun
      bc # calculator
      bind # Provides dig
      dconf # Gnome configuration database
      difftastic # structural diff difft, see https://github.com/Wilfred/difftastic
      dive # Analyze docker images
      dmidecode # Hardware info read from Bios
      dnstracer
      efivar # Tools and Libraries to manipulate EFI variables
      fast-cli # Fast.com CLI `fast`
      fastfetch # neofetch sucessor, system information tool
      fd # Better find, written in Rust
      ffmpeg-full
      file # CLI program to show the type of a file
      find-cursor
      fortune
      glow # Terminal markdown renderer
      gomatrix # The Matrix
      google-chrome
      gucharmap # Unicode Character Map
      hardinfo2 # Hardware/System Info
      httpie
      iftop # Net top tool, see also nethogs
      imagemagick
      iotop-c
      jq
      kind # Kubernetes In Docker
      plasma5Packages.kruler # Screen ruler
      lazydocker # kind for vanilla Docker, kind of
      libnotify # Provides notify-send
      libsecret # `secret-tool` for interacting with gnome-keyring
      lm_sensors # Tools for reading hardware sensors
      lolcat # Pipe and See
      lsof # Tool to list open file
      ncdu # Disk Space Usage Visualization
      nmap # Port Scanner
      nethogs # Net top tool, see also iftop
      neo-cowsay
      nix-tree
      oculante # img viewer written in Rust
      kdePackages.okular # KDE document viewer
      openssl
      pdftk # PDF Manipulation Toolkit
      pstree # Show the set of running processes as a tree
      q-text-as-data # https://github.com/harelba/q
      inputs.rmob.defaultPackage.x86_64-linux
      screenkey # Screencast tool to display your keys inspired by Screenflick
      smartmontools # Tools for monitoring the health of hard drives
      s-tui # Processor monitor/stress test
      stress # Simple workload generator for POSIX systems. It imposes a configurable amount of CPU, memory, I/O, and disk stress on the system
      tcpdump
      traceroute
      tree
      unzip
      usbutils # Provides lsusb
      wdisplays # arandr for wayland - external display/screen GUI
      wf-recorder # Screen recorder for Wayland, useful for quick testing screen stuff
      wget
      wireguard-tools
      whois
      wl-clipboard
      xournalpp # PDF Annotations, useful for saving Okular annotations as well
      yq # Command-line YAML/XML/TOML processor - jq wrapper for YAML, XML, TOML documents
      yt-dlp
      zip
    ];

    sessionVariables =
      {
        PATH = "$HOME/bin:$PATH";
        NIXOS_CONFIG = "$HOME/code/nixos-config/";
        DIRENV_LOG_FORMAT = ""; # Disable verbose direnv output showing env variables changed
        NIXOS_OZONE_WL = "1"; # Enable Ozone-Wayland for Electron apps and Chromium
      }
      // lib.optionalAttrs isNvidia {
        LIBVA_DRIVER_NAME = "nvidia";
      };
  };

  inherit imports;

  programs = {
    bat = {
      enable = true;
    };

    man = {
      enable = true;
      generateCaches = false; # Speed up builds
    };

    vscode = {
      enable = true;
    };
  };
}
