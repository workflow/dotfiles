{inputs, ...}: {
  flake.modules.homeManager.home-cleanup-todo = {
    config,
    lib,
    osConfig,
    pkgs,
    ...
  }: {
    # Symlink flake for `home-manager news` CLI to find homeConfigurations
    home.file."nixos-config" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config";
      target = "nixos-config";
    };

    home.file.".config/home-manager/flake.nix" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/flake.nix";
    };

    home.packages = with pkgs; [
      alejandra # Nix Formatter
      ast-grep # Pure Magic
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
      home-manager # CLI for managing home-manager, needed for `home-manager news`
      httpie
      iftop # Net top tool, see also nethogs
      imagemagick
      iotop-c
      jq
      kind # Kubernetes In Docker
      kdePackages.kruler # Screen ruler
      lazydocker # kind for vanilla Docker, kind of
      libnotify # Provides notify-send
      libsecret # `secret-tool` for interacting with gnome-keyring
      lm_sensors # Tools for reading hardware sensors
      lolcat # Pipe and See
      lsof # Tool to list open file
      ncdu # Disk Space Usage Visualization
      nmap # Port Scanner
      nethogs # Net top tool, see also iftop
      net-tools # Things like arp, ifconfig, route, netstat etc...
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

    home.sessionVariables =
      {
        PATH = "$HOME/bin:$PATH";
        NIXOS_CONFIG = "$HOME/code/nixos-config/";
        GC_INITIAL_HEAP_SIZE = "8G"; # Slightly improve nix eval times
        DIRENV_LOG_FORMAT = ""; # Disable verbose direnv output showing env variables changed
        NIXOS_OZONE_WL = "1"; # Enable Ozone-Wayland for Electron apps and Chromium
      }
      // lib.optionalAttrs osConfig.dendrix.hasNvidia {
        LIBVA_DRIVER_NAME = "nvidia";
      };

    programs.bat = {
      enable = true;
    };

    programs.man = {
      enable = true;
      generateCaches = false; # Speed up builds
    };

    programs.vscode = {
      enable = true;
    };
  };
}
