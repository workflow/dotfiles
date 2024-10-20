{
  lib,
  isNvidia,
  pkgs,
  secrets,
  ...
}: let
  homePackages = with pkgs; [
    unstable.aichat
    alejandra # nix formatter
    bluetuith
    brave
    dive # Analyze docker images
    find-cursor
    twentythreeeleven.galaxy-buds-client
    unstable.hoppscotch # Open-Source Postman
    twentythreeeleven.jetbrains.idea-ultimate
    libation
    lolcat
    neo-cowsay
    networkmanager_dmenu
    nix-tree
    oculante # img viewer written in Rust
    portfolio
    rclone
    restic
    unstable.ytmdesktop
  ];

  homeScripts = with scripts; [
    cloaking-rules-from-hosts
    dlfile
    font-smoke-test
    macgyver-status
    obs-mic
    sound-switcher
    tailscale-ip
  ];

  imports =
    [
      ./home/alacritty.nix
      ./home/aliases.nix
      ./home/autorandr.nix
      ./home/bash
      ./home/broot.nix
      ./home/btop
      ./home/email.nix
      ./home/firefox
      ./home/fish.nix
      ./home/fzf.nix
      ./home/git.nix
      ./home/gpg.nix
      ./home/gtk-qt
      ./home/i3
      ./home/i3status-rust.nix
      ./home/k9s
      ./home/lf.nix
      ./home/neovim
      ./home/nix-index
      ./home/nushell
      ./home/obs
      ./home/picom.nix
      ./home/redshift.nix
      ./home/starship
      ./home/stylix
      ./home/syncthing
      ./home/urxvt.nix
      ./home/xdg.nix
      ./home/xsession

      ./home/programs/networkmanager-dmenu
      ./home/programs/nh
      ./home/programs/rofi
      ./home/programs/rofimoji

      ./home/services/clipcat
      ./home/services/dunst
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

      # Parcellite
      ".config/parcellite/parcelliterc".source = ./dotfiles/parcelliterc;

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

      # Syncthing tray
      ".config/syncthingtray.ini".source = ./dotfiles/syncthingtray.ini;

      # Variety
      ".config/variety/variety.conf".source = ./dotfiles/variety.conf;
    };

    keyboard = {
      layout = "us,de,ua,pt";
      options = ["grp:ctrls_toggle" "eurosign:e" "caps:escape_shifted_capslock" "terminate:ctrl_alt_bksp"];
    };

    packages = homePackages ++ homeScripts;

    sessionVariables = {
      PATH = "$HOME/bin:$PATH";
      NIXOS_CONFIG = "$HOME/code/nixos-config/";
      BROWSER = "brave";
      DEFAULT_BROWSER = "brave";
      DIRENV_LOG_FORMAT = ""; # Disable verbose direnv output showing env variables changed
      LIBVA_DRIVER_NAME =
        if isNvidia
        then "nvidia"
        else null;
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
    lorri.enable = true;

    flameshot = {
      package = pkgs.unstable.flameshot;
      enable = true;
      settings = {
        General = {
          copyPathAfterSave = true;
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
        };
      };
    };

    parcellite.enable = true;

    udiskie = {
      enable = true;
      automount = false;
    };

    unclutter.enable = true;
  };
}
