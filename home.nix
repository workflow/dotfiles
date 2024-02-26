{ config, lib, pkgs, secrets, osConfig, ... }:
let
  hostName = osConfig.networking.hostName;

  imports = [
    ./home/alacritty.nix
    ./home/autorandr.nix
    ./home/broot.nix
    ./home/dunst.nix
    ./home/email.nix
    ./home/fish.nix
    ./home/fzf.nix
    ./home/git.nix
    ./home/gpg.nix
    ./home/gtk.nix
    ./home/i3status-rust.nix
    ./home/lf.nix
    ./home/neovim
    ./home/nushell.nix
    ./home/picom.nix
    ./home/redshift.nix
    ./home/rofi.nix
    ./home/starship.nix
    ./home/urxvt.nix
    ./home/xdg.nix
    ./home/xsession
  ] ++ secretImports;

  nixpkgs-unstable = pkgs.unstable;

  profile = pkgs.callPackage ./lib/profile.nix { };

  scripts = pkgs.callPackage ./lib/scripts.nix { inherit nixpkgs-unstable; };

  secretImports = lib.optionals (secrets ? homeManagerSecrets) [
    secrets.homeManagerSecrets
  ];

in
{

  _module.args = { inherit profile; };

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

      # ~/bin
      # Declaratively configure Mega backups
      "bin/configure-mega-backup" = { text = scripts.configure-mega-backup; executable = true; };

      # Dlfile (reverse drag-and-drop with dragon)
      "bin/dlfile" = { text = scripts.dlfile; executable = true; };

      # Duplicati
      ".backup/duplicati-config-nix/${hostName}+Full+Backup-duplicati-config.json.aes" = lib.mkIf (secrets ? duplicatiConfig) {
        source = lib.attrsets.attrByPath [ "${hostName}" ] { } secrets.duplicatiConfig;
      };

      # Generate gitignores
      "bin/gen-gitignore" = { text = scripts.gen-gitignore; executable = true; };

      # Nixos script wrapper
      "bin/nixos" = { text = scripts.nixos; executable = true; };

      # gh (Github CLI)
      ".config/gh/config.yml".source = ./dotfiles/gh.config.yml;

      # IdeaVIM
      ".ideavimrc".source = ./dotfiles/ideavimrc;

      # Get Macgyver status
      "bin/macgyver-status" = { text = scripts.macgyver-status; executable = true; };

      # Patch Minikube kvm2 driver, see https://github.com/NixOS/nixpkgs/issues/115878
      ".minikube/bin/docker-machine-driver-kvm2".source = "${pkgs.docker-machine-kvm2}/bin/docker-machine-driver-kvm2";

      # Maven
      ".m2/settings.xml" = lib.mkIf (secrets ? mavenConfig) {
        source = secrets.mavenConfig;
      };

      # Parcellite
      ".config/parcellite/parcelliterc".source = ./dotfiles/parcelliterc;

      # Pistol
      ".config/pistol/pistol.conf".source = ./dotfiles/pistol.conf;

      # Pulsemixer
      ".config/pulsemixer.cfg".source = ./dotfiles/pulsemixer.cfg;

      # PSQL
      ".psqlrc".source = ./dotfiles/psqlrc;

      # Rmview (Remarkable II screensharing) config
      ".config/rmview.json".source = ./dotfiles/rmviewconfig.json;

      # Sound Switcher
      "bin/sound-switcher" = { source = ./home/scripts/sound-switcher.sh; executable = true; };

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
      "bin/tailscale-ip" = { text = scripts.tailscale-ip; executable = true; };

      # Variety
      ".config/variety/variety.conf".source = ./dotfiles/variety.conf;
    };

    keyboard = {
      layout = "us,de,ua,pt";
      options = [ "grp:ctrls_toggle" "eurosign:e" "caps:escape_shifted_capslock" "terminate:ctrl_alt_bksp" ];
    };

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

    nix-index = {
      enable = true;
    };

    obs-studio = {
      enable = true;
    };

    ssh = {
      enable = true;
      matchBlocks = {
        syncthing = {
          hostname = "34.124.137.146";
          user = "farlion";
        };
        autoriza = {
          hostname = "148.63.20.188";
          user = "autoriza";
          port = 4343;
        };
      };
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

  qt = {
    enable = true;
    platformTheme = "gnome";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  services = {
    lorri.enable = true;

    flameshot = {
      package = nixpkgs-unstable.flameshot;
      enable = true;
      settings = {
        General = {
          copyPathAfterSave = true;
        };
      };
    };

    network-manager-applet.enable = true;

    parcellite.enable = true;

    pasystray.enable = true;

    syncthing = {
      enable = true;
    };

    udiskie.enable = true;

    unclutter.enable = true;
  };


}
