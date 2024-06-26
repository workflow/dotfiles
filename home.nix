{
  inputs,
  lib,
  pkgs,
  secrets,
  osConfig,
  ...
}: let
  hostName = osConfig.networking.hostName;

  imports =
    [
      ./home/alacritty.nix
      ./home/autorandr.nix
      ./home/bash
      ./home/broot.nix
      ./home/email.nix
      ./home/fish.nix
      ./home/fzf.nix
      ./home/git.nix
      ./home/gpg.nix
      ./home/i3
      ./home/i3status-rust.nix
      ./home/lf.nix
      ./home/neovim
      ./home/nix-index
      ./home/nushell
      ./home/obs
      ./home/picom.nix
      ./home/redshift.nix
      ./home/starship
      ./home/syncthing
      ./home/urxvt.nix
      ./home/xdg.nix
      ./home/xsession

      ./home/gtk-qt

      ./home/programs/networkmanager-dmenu
      ./home/programs/nh
      ./home/programs/rofi
      ./home/programs/rofimoji

      ./home/services/clipcat
      ./home/services/dunst
    ]
    ++ secretImports;

  nixpkgs-unstable = pkgs.unstable;

  profile = pkgs.callPackage ./lib/profile.nix {};

  scripts = pkgs.callPackage ./lib/scripts.nix {inherit nixpkgs-unstable;};

  secretImports = lib.optionals (secrets ? homeManagerSecrets) secrets.homeManagerSecrets;
in {
  _module.args = {inherit profile;};

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

      # dnscrypt cloaking rules from /etc/hosts
      "bin/cloaking-rules-from-hosts" = {
        source = ./home/scripts/cloaking-rules-from-hosts.sh;
        executable = true;
      };

      # Dlfile (reverse drag-and-drop with dragon)
      "bin/dlfile" = {
        text = scripts.dlfile;
        executable = true;
      };

      # Duplicati
      ".backup/duplicati-config-nix/${hostName}+Full+Backup-duplicati-config.json.aes" = lib.mkIf (secrets ? duplicatiConfig) {
        source = lib.attrsets.attrByPath ["${hostName}"] {} secrets.duplicatiConfig;
      };

      # Font smoke-test
      "bin/font-smoke-test" = {
        text = scripts.font-smoke-test;
        executable = true;
      };

      # Generate gitignores
      "bin/gen-gitignore" = {
        text = scripts.gen-gitignore;
        executable = true;
      };

      # gh (Github CLI)
      ".config/gh/config.yml".source = ./dotfiles/gh.config.yml;

      # IdeaVIM
      ".ideavimrc".source = ./dotfiles/ideavimrc;

      # Obs Virtual Mic
      "bin/obs-mic" = {
        source = ./home/scripts/obs-mic.sh;
        executable = true;
      };

      # Get Macgyver status
      "bin/macgyver-status" = {
        text = scripts.macgyver-status;
        executable = true;
      };

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

      # Sound Switcher
      "bin/sound-switcher" = {
        source = ./home/scripts/sound-switcher.sh;
        executable = true;
      };

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

      # Get tailscale IP if online
      "bin/tailscale-ip" = {
        text = scripts.tailscale-ip;
        executable = true;
      };

      # Variety
      ".config/variety/variety.conf".source = ./dotfiles/variety.conf;
    };

    keyboard = {
      layout = "us,de,ua,pt";
      options = ["grp:ctrls_toggle" "eurosign:e" "caps:escape_shifted_capslock" "terminate:ctrl_alt_bksp"];
    };

    packages = with pkgs; [
      unstable.aichat
      alejandra # nix formatter
      bluetuith
      find-cursor
      twentythreeeleven.galaxy-buds-client
      helvum # GTK patchbay for Pipewire
      unstable.hoppscotch # Open-Source Postman
      twentythreeeleven.jetbrains.idea-ultimate
      lolcat
      neo-cowsay
      networkmanager_dmenu
      nix-tree
      rclone
      restic
    ];

    sessionVariables = {
      PATH = "$HOME/bin:$PATH";
      NIXOS_CONFIG = "$HOME/code/nixos-config/";
      BROWSER = "brave";
      DEFAULT_BROWSER = "brave";
      DIRENV_LOG_FORMAT = ""; # Disable verbose direnv output showing env variables changed
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
      config = {
        theme = "ansi";
      };
      enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.strict_env = true; # Forces all .envrc scripts through set -euo pipefail
    };

    firefox = {
      enable = true;
      profiles = {
        main = {
          id = 0;
          isDefault = true;
        };
        mul = {
          id = 1;
          isDefault = false;
        };
        tom = {
          id = 2;
          isDefault = false;
        };
      };
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
      package = nixpkgs-unstable.flameshot;
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
