{
  lib,
  isNvidia,
  pkgs,
  secrets,
  ...
}: let
  homePackages = with pkgs; [
    aichat
    alejandra # nix formatter
    autotiling # autotiling script for sway
    bluetuith
    brave
    calibre # Ebook reader
    dive # Analyze docker images
    find-cursor
    galaxy-buds-client
    glow # Terminal markdown renderer
    hoppscotch # Open-Source Postman
    unstable.isd # Interactive Systemd TUI in Python
    kind
    libation
    libsecret # `secret-tool` for interacting with gnome-keyring
    lnav # Log File Navigator
    lolcat
    neo-cowsay
    networkmanager_dmenu
    nix-tree
    oculante # img viewer written in Rust
    portfolio
    rclone
    restic
    teams-for-linux # Unofficial Msft Teams App
    todoist-electron # Official Todoist app
    wealthfolio
    wdisplays # arandr for wayland - external display/screen GUI
    wl-clipboard
    ytmdesktop
    xdg-desktop-portal
    zip
  ];

  homeScripts = with scripts; [
    cloaking-rules-from-hosts
    dlfile
    font-smoke-test
    macgyver-status
    sound-switcher-boar
    sound-switcher-flexbox
    tailscale-ip
  ];

  imports =
    [
      ./home/modules/yubikey-touch-detector

      ./home/alacritty.nix
      ./home/aliases.nix
      ./home/bash
      ./home/broot.nix
      ./home/btop
      ./home/cliphist
      ./home/cpu-profile-toggler
      ./home/ddc-backlight
      ./home/dunst
      ./home/email.nix
      ./home/firefox
      ./home/fish.nix
      ./home/fix-flexbox-mike # Fix ALSA not detecting microphone on XPS 9700
      ./home/flameshot
      ./home/fzf.nix
      ./home/git.nix
      ./home/gpg.nix
      ./home/gtk-qt
      ./home/sway
      ./home/i3status-rust
      ./home/k9s
      ./home/kanshi # Wayland autorandr
      ./home/kind-with-local-registry
      ./home/lf.nix
      ./home/neovim
      ./home/nix-index
      ./home/nushell
      ./home/obs
      ./home/sound-levels-maintainer
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
        QT_QPA_PLATFORM = "wayland";
        NIXOS_OZONE_WL = 1; # Enable Ozone-Wayland for Electron apps and Chromium, see https://nixos.wiki/wiki/Wayland
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
