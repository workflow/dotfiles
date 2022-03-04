{ config, lib, pkgs, ... }:
let
  imports = [
    ./home/alacritty.nix
    ./home/autorandr.nix
    ./home/broot.nix
    ./home/dunst.nix
    ./home/fzf.nix
    ./home/git.nix
    ./home/i3status-rust.nix
    ./home/lf.nix
    ./home/neovim.nix
    ./home/picom.nix
    ./home/rofi.nix
    ./home/urxvt.nix
    ./home/xsession
  ];

  fishrc = pkgs.callPackage ./dotfiles/fishrc.nix { inherit profile; };

  nixpkgs-unstable = import sources.nixpkgs-unstable { config.allowUnfree = true; };

  nur = import sources.NUR { inherit pkgs; };

  profile = pkgs.callPackage ./dotfiles/profile.nix { };

  scripts = pkgs.callPackage ./dotfiles/scripts.nix { inherit nixpkgs-unstable; };

  sources = import ./nix/sources.nix;

in
{

  home = {
    file = {
      # ~/bin
      # Declaratively configure Mega backups
      "bin/configure-mega-backup" = { text = scripts.configure-mega-backup; executable = true; };

      # Dlfile (reverse drag-and-drop with dragon)
      "bin/dlfile" = { text = scripts.dlfile; executable = true; };

      # gh (Github CLI)
      ".config/gh/config.yml".source = ./dotfiles/gh.config.yml;

      # IdeaVIM
      ".ideavimrc".source = ./dotfiles/ideavimrc;

      # Less
      # TODO: This might now be supported natively, see home-manager news
      ".lesskey" = {
        onChange = "lesskey";
        source = ./dotfiles/lesskey;
      };

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
      # As a safety measure, install the config only after synchronization has first happened
      ".config/syncthing/config.xml" = lib.mkIf (lib.pathExists /home/farlion/code) {
        source = /home/farlion/code/nixos-secrets/dotfiles/syncthing.xml;
      };
      "code/.stignore" = lib.mkIf (lib.pathExists /home/farlion/code) {
        source = ./dotfiles/stignore_code;
      };
      ".ssh/.stignore".source = ./dotfiles/stignore_ssh;

      # Syncthing tray
      ".config/syncthingtray.ini".source = ./dotfiles/syncthingtray.ini;

      # Variety
      ".config/variety/variety.conf".source = ./dotfiles/variety.conf;
    };

    sessionVariables = {
      PATH = "$HOME/bin:$PATH";
    };

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "20.03";
  };

  inherit imports;

  gtk = {
    enable = true;
    font = {
      name = "Fira Code 9";
    };
    iconTheme = {
      name = "Pop";
      package = nixpkgs-unstable.pop-icon-theme;
    };
    theme = {
      name = "Pop";
      package = pkgs.pop-gtk-theme;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs = {
    bat = {
      config = {
        theme = "ansi-dark";
      };
      enable = true;
    };

    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    firefox = {
      enable = true;
      # extensions = with nur.repos.rycee.firefox-addons; [
      #   lastpass-password-manager
      #   privacy-badger
      # ];
      profiles = {
        main = { };
      };
    };

    fish = {
      enable = true;
      interactiveShellInit = fishrc.shellInit;
      functions = fishrc.functions;
      plugins = fishrc.plugins;
      shellAbbrs = profile.aliases;
    };

    htop.enable = true;

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
    platformTheme = "gtk";
  };

  services = {
    lorri.enable = true;

    flameshot.enable = true;

    network-manager-applet.enable = true;

    parcellite.enable = true;

    pasystray.enable = true;

    syncthing = {
      enable = true;
      tray = {
        enable = true;
        command = "syncthingtray --wait";
      };
    };

    udiskie.enable = true;

    unclutter.enable = true;
  };

}
