{
  lib,
  isImpermanent,
  isNvidia,
  inputs,
  pkgs,
  secrets,
  ...
}: let
  homePackages = with pkgs; [
    alejandra # Nix Formatter
    ast-grep # Pure Magic
    asciinema # Terminal recording fun
    autotiling # autotiling script for sway
    bc # calculator
    bind # Provides dig
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
    unstable.isd # Interactive Systemd TUI in Python
    jq
    kind # Kubernetes In Docker
    plasma5Packages.kruler # Screen ruler
    lazydocker # kind for vanilla Docker, kind of
    libnotify # Provides notify-send
    libsecret # `secret-tool` for interacting with gnome-keyring
    lm_sensors # Tools for reading hardware sensors
    lnav # Log File Navigator
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
    qalculate-gtk # Calculator
    q-text-as-data # https://github.com/harelba/q
    remmina # Remote Desktop Client
    ripgrep # rg
    inputs.rmob.defaultPackage.x86_64-linux
    rmview # Remarkable Screen Sharing
    screenkey # Screencast tool to display your keys inspired by Screenflick
    smartmontools # Tools for monitoring the health of hard drives
    s-tui # Processor monitor/stress test
    stress # Simple workload generator for POSIX systems. It imposes a configurable amount of CPU, memory, I/O, and disk stress on the system
    tcpdump
    traceroute
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

  homeScripts = with scripts; [
    cloaking-rules-from-hosts
    dlfile
    font-smoke-test
    macgyver-status
    tailscale-ip
  ];

  impermanenceImports =
    [
      inputs.impermanence.homeManagerModules.impermanence
    ]
    ++ lib.optionals isImpermanent [
      ./impermanence
    ];

  imports =
    [
      ./modules/yubikey-touch-detector

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
      ./k9s
      ./kanshi # Wayland autorandr
      ./kind-with-local-registry
      ./kubernetes-tools
      ./lf
      ./libation # Audible liberator
      ./libreoffice
      ./mic-levels-maintainer
      ./neovim
      ./networkmanager-dmenu
      ./nh # https://github.com/nix-community/nh
      ./nix-index
      ./nushell
      ./obs
      ./portfolio-performance
      ./rofi
      ./rofimoji
      ./solaar # Linux devices manager for the Logitech Unifying Receiver
      ./sound-switcher
      ./starship
      ./stylix
      ./sway
      ./syncthing
      ./systemd-errors-and-warnings-counter
      ./todoist # Official Todoist app
      ./udiskie
      ./urxvt
      ./virtual-cable
      ./wlsunset
      ./xdg
      ./ytmdesktop # Youtube Music Desktop (unofficial)
    ]
    ++ impermanenceImports
    ++ secretImports;

  scripts = pkgs.callPackage ./scripts {};

  secretImports = lib.optionals (secrets ? homeManagerSecrets) secrets.homeManagerSecrets;
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
    stateVersion = "22.05";

    file = {
      # Cargo
      ".cargo/config.toml" = lib.mkIf (secrets ? cargoConfig) {
        source = secrets.cargoConfig;
      };
      ".cargo/config-mold.toml" = lib.mkIf (secrets ? cargoMoldConfig) {
        source = secrets.cargoMoldConfig;
      };

      # gh (Github CLI)
      ".config/gh/config.yml".source = ./dotfiles/gh.config.yml;

      # IdeaVIM
      ".ideavimrc".source = ./dotfiles/ideavimrc;

      # Patch Minikube kvm2 driver, see https://github.com/NixOS/nixpkgs/issues/115878
      ".minikube/bin/docker-machine-driver-kvm2".source = "${pkgs.docker-machine-kvm2}/bin/docker-machine-driver-kvm2";

      # Maven
      ".m2/settings.xml" = lib.mkIf (secrets ? mavenConfig) {
        source = secrets.mavenConfig;
      };

      # Pulsemixer
      ".config/pulsemixer.cfg".source = ./dotfiles/pulsemixer.cfg;

      # PSQL
      ".psqlrc".source = ./dotfiles/psqlrc;

      # Rmview (Remarkable II screensharing) config
      ".config/rmview.json".source = ./dotfiles/rmviewconfig.json;

      # Syncthing
      ".config/syncthing/config.xml" = lib.mkIf (secrets ? syncthingConfig) {
        text = secrets.syncthingConfig;
      };

      "code/.stignore" = {
        source = ./dotfiles/stignore_code;
      };
      ".ssh/.stignore".source = ./dotfiles/stignore_ssh;

      # Variety
      ".config/variety/variety.conf".source = ./dotfiles/variety.conf;
    };

    packages = homePackages ++ homeScripts;

    sessionVariables =
      {
        PATH = "$HOME/bin:$PATH";
        NIXOS_CONFIG = "$HOME/code/nixos-config/";
        BROWSER = "brave --enable-features='VaapiVideoDecoder,VaapiVideoEncoder' --enable-raw-draw --password-store=seahorse";
        DEFAULT_BROWSER = "brave --enable-features='VaapiVideoDecoder,VaapiVideoEncoder' --enable-raw-draw --password-store=seahorse";
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

  pam.yubico.authorizedYubiKeys.ids = [
    "cccccchvrtfg"
  ];

  programs = {
    bat = {
      enable = true;
    };

    direnv = {
      # TODO: impermanence: .local/share/direnv (move from general home impermanence)
      enable = true;
      nix-direnv.enable = true;
      config.strict_env = true; # Forces all .envrc scripts through set -euo pipefail
    };

    htop.enable = true;

    less = {
      enable = true;
      keys = ''
        k forw-line
        l back-line
      '';
    };

    ssh = {
      enable = true;
      extraConfig = ''
        PubkeyAcceptedKeyTypes +ssh-rsa
        HostKeyAlgorithms +ssh-rsa
      '';
    };

    tealdeer = {
      enable = true;
      settings = {
        updates = {
          auto_update = true;
        };
      };
    };

    vscode = {
      enable = true;
    };

    zoxide = {
      enable = true;
    };
  };

  services = {
    yubikey-touch-detector.enable = true;
  };
}
