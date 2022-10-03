{ config, lib, pkgs, secrets, ... }:
let
  imports = [
    ./home/alacritty.nix
    ./home/autorandr.nix
    ./home/broot.nix
    ./home/dunst.nix
    ./home/fish.nix
    ./home/fzf.nix
    ./home/git.nix
    ./home/gtk.nix
    ./home/i3status-rust.nix
    ./home/lf.nix
    ./home/neovim.nix
    ./home/nushell.nix
    ./home/picom.nix
    ./home/rofi.nix
    ./home/starship.nix
    ./home/urxvt.nix
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

      # ~/bin
      # Declaratively configure Mega backups
      "bin/configure-mega-backup" = { text = scripts.configure-mega-backup; executable = true; };

      # Dlfile (reverse drag-and-drop with dragon)
      "bin/dlfile" = { text = scripts.dlfile; executable = true; };

      # Nixos script wrapper
      "bin/nixos" = { text = scripts.nixos; executable = true; };

      # gh (Github CLI)
      ".config/gh/config.yml".source = ./dotfiles/gh.config.yml;

      # IdeaVIM
      ".ideavimrc".source = ./dotfiles/ideavimrc;

      # Patch Minikube kvm2 driver, see https://github.com/NixOS/nixpkgs/issues/115878
      ".minikube/bin/docker-machine-driver-kvm2".source = "${pkgs.docker-machine-kvm2}/bin/docker-machine-driver-kvm2";

      # Nvim
      ".config/nvim/coc-settings.json".source = ./dotfiles/coc-settings.json;

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

      # Syncthing
      ".config/syncthing/config.xml" = lib.mkIf (secrets ? syncthingConfig) {
        source = secrets.syncthingConfig;
      };

      # Set ignore files only when code/ dir is present (flake mode)
      "code/.stignore" = lib.mkIf (secrets ? syncthingConfig) {
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
      options = [ "grp:ctrls_toggle" "eurosign:e" "caps:escape_shifted_capslock" "terminate:ctrl_alt_bksp" ];
    };

    sessionVariables = {
      PATH = "$HOME/bin:$PATH";
      NIXOS_CONFIG = "$HOME/code/nixos-config/";
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
        theme = "ansi-dark";
      };
      enable = true;
    };

    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    exa.enable = true;

    firefox = {
      enable = true;
      profiles = {
        main = { };
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
          hostname = "34.124.158.69";
          user = "farlion";
        };
      };
      extraConfig = ''
        PubkeyAcceptedKeyTypes +ssh-rsa
        HostKeyAlgorithms +ssh-rsa
      '';
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

    flameshot.enable = true;

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
