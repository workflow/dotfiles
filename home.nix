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
    devenv # devenv.sh
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
    gparted
    gptfdisk # gdisk
    gucharmap # Unicode Character Map
    hardinfo # Hardware/System Info
    httpie
    iftop # Network Interface top
    imagemagick
    iotop-c
    unstable.isd # Interactive Systemd TUI in Python
    jq
    kind # Kubernetes In Docker
    plasma5Packages.kruler # Screen ruler
    lazydocker # kind for vanilla Docker, kind of
    libsecret # `secret-tool` for interacting with gnome-keyring
    lnav # Log File Navigator
    lolcat # Pipe and See
    neo-cowsay
    nix-tree
    oculante # img viewer written in Rust
    rclone
    restic
    tcpdump
    teams-for-linux # Unofficial Msft Teams App
    todoist-electron # Official Todoist app
    wealthfolio
    wdisplays # arandr for wayland - external display/screen GUI
    wf-recorder # Screen recorder for Wayland, useful for quick testing screen stuff
    wl-clipboard
    ytmdesktop
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
      ./home/impermanence
    ];

  imports =
    [
      ./home/modules/yubikey-touch-detector

      ./home/aichat.nix
      ./home/alacritty.nix
      ./home/aws
      ./home/aliases.nix
      ./home/bash
      ./home/bluetuith # Bluetooth TUI
      ./home/brave-browser
      ./home/broot.nix
      ./home/btop
      ./home/calibre # Ebook reader
      ./home/cliphist
      ./home/cpu-profile-toggler
      ./home/ddc-backlight
      ./home/dunst
      ./home/easyeffects # GUI for Pipewire effects
      ./home/email.nix
      ./home/firefox
      ./home/fish.nix
      ./home/fix-flexbox-mike # Fix ALSA not detecting microphone on XPS 9700
      ./home/flameshot
      ./home/fzf.nix
      ./home/galaxy-buds-client
      ./home/git.nix
      ./home/gtk-qt
      ./home/sway
      ./home/i3status-rust
      ./home/k9s
      ./home/kanshi # Wayland autorandr
      ./home/kind-with-local-registry
      ./home/lf.nix
      ./home/libation # Audible liberator
      ./home/neovim
      ./home/nix-index
      ./home/nushell
      ./home/obs
      ./home/portfolio-performance
      ./home/mic-levels-maintainer
      ./home/sound-switcher
      ./home/starship
      ./home/stylix
      ./home/syncthing
      ./home/systemd-errors-and-warnings-counter
      ./home/udiskie
      ./home/urxvt.nix
      ./home/virtual-cable
      ./home/wlsunset
      ./home/xdg.nix

      ./home/programs/networkmanager-dmenu
      ./home/programs/nh
      ./home/programs/rofi
      ./home/programs/rofimoji
    ]
    ++ impermanenceImports
    ++ secretImports;

  scripts = pkgs.callPackage ./home/scripts {};

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

      # Pistol
      ".config/pistol/pistol.conf".source = ./dotfiles/pistol.conf;

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
