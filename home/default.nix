{
  lib,
  isImpermanent,
  isNvidia,
  inputs,
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
      ./ddc-backlight
      ./devenv # devenv.sh
      ./direnv
      ./discord
      ./dunst
      ./easyeffects # GUI for Pipewire effects
      ./email
      ./firefox
      ./fish
      ./fix-flexbox-mike # Fix ALSA not detecting microphone on XPS 9700
      ./flameshot
      ./fzf
      ./galaxy-buds-client
      ./gimp
      ./git
      ./gtk-qt
      ./i3status-rust
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
      ./nix-index
      ./nushell
      ./obs # OBS Studio
      ./obsidian
      ./portfolio-performance
      ./psql # Postgresql Client with nicer config
      ./pulsemixer # TUI (curses) mixer for pulseaudio, still useful under pipewire
      ./qalculate # Calculator
      ./remmina # Remote Desktop Client
      ./rofi
      ./rofimoji
      ./signal
      ./solaar # Linux devices manager for the Logitech Unifying Receiver
      ./sound-switcher
      ./ssh
      ./starship
      ./stylix
      ./sway
      ./syncthing
      ./systemd-errors-and-warnings-counter
      ./tealdeer
      ./telegram
      ./todoist # Official Todoist app
      ./trash-cli
      ./udiskie
      ./urxvt
      ./variety # Wallpaper Switcher/Randomizer with Quotes
      ./virtual-cable
      ./vlc
      ./wlsunset # Day/night gamma adjustments for Wayland
      ./xdg
      ./ytmdesktop # Youtube Music Desktop (unofficial)
      ./yubico # Yubikeys
      ./zoom
      ./zoxide
    ]
    ++ impermanenceImports
    ++ [homeManagerSecrets];

  isFlexbox = osConfig.networking.hostName == "flexbox";
  isNumenor = osConfig.networking.hostName == "numenor";

  homeManagerSecrets =
    if secrets ? homeManagerSecrets
    then secrets.homeManagerSecrets {inherit isImpermanent lib pkgs;}
    else {};
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

    packages = with pkgs; [
      alejandra # Nix Formatter
      ast-grep # Pure Magic
      asciinema # Terminal recording fun
      autotiling # autotiling script for sway
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
      hardinfo # Hardware/System Info
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
      okular # KDE document viewer
      openssl
      pavucontrol # Pulse Audio Volume Control GUI
      pdftk # PDF Manipulation Toolkit
      pstree # Show the set of running processes as a tree
      q-text-as-data # https://github.com/harelba/q
      ripgrep # rg
      inputs.rmob.defaultPackage.x86_64-linux
      screenkey # Screencast tool to display your keys inspired by Screenflick
      smartmontools # Tools for monitoring the health of hard drives
      s-tui # Processor monitor/stress test
      stress # Simple workload generator for POSIX systems. It imposes a configurable amount of CPU, memory, I/O, and disk stress on the system
      tcpdump
      traceroute
      tree
      thefuck
      unzip
      usbutils # Provides lsusb
      wdisplays # arandr for wayland - external display/screen GUI
      wf-recorder # Screen recorder for Wayland, useful for quick testing screen stuff
      wget
      wireguard-tools
      whois
      wl-clipboard
      xournal # PFD Annotations, useful for saving Okular annotations as well
      yq # Command-line YAML/XML/TOML processor - jq wrapper for YAML, XML, TOML documents
      yt-dlp
      zip
    ];

    sessionVariables =
      {
        PATH = "$HOME/bin:$PATH";
        NIXOS_CONFIG = "$HOME/code/nixos-config/";
        DIRENV_LOG_FORMAT = ""; # Disable verbose direnv output showing env variables changed
      }
      // lib.optionalAttrs isNvidia {
        LIBVA_DRIVER_NAME = "nvidia";
      };
  };

  inherit imports;

  nixpkgs.config = {
    allowUnfree = true;
  };

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
