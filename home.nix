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

      # gh (Github CLI)
      ".config/gh/config.yml".source = ./dotfiles/gh.config.yml;

      # IdeaVIM
      ".ideavimrc".source = ./dotfiles/ideavimrc;

      # Less
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

      # Syncthing
      # As a safety measure, install the config only after synchronization has first happened
      ".config/syncthing/config.xml" = lib.mkIf (lib.pathExists /home/farlion/code) {
        source = ./dotfiles/syncthing.xml;
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

    firefox = {
      enable = true;
      extensions = with nur.repos.rycee.firefox-addons; [
        lastpass-password-manager
        privacy-badger
      ];
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

    obs-studio = {
      enable = true;
    };

    ssh = {
      enable = true;
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
    };

    udiskie.enable = true;

    unclutter.enable = true;
  };

}
