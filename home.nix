{ config, lib, pkgs, ... }:
let
  imports = [
    ./home/autorandr.nix
    ./home/dunst.nix
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

      # i3status-rust
      ".config/i3status-rust/config.toml".source = ./dotfiles/i3status-rust-config.toml;

      # IdeaVIM
      ".ideavimrc".source = ./dotfiles/ideavimrc;

      # Less
      ".lesskey" = {
        onChange = "lesskey";
        source = ./dotfiles/lesskey;
      };

      # Syncthing
      ".config/syncthing/config.xml".source = ./dotfiles/syncthing.xml;
      "code/.stignore".source = ./dotfiles/stignore_code;
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

    git = {
      aliases = {
        c = "commit";
        p = "push";
      };
      enable = true;
      ignores = [ ".idea" ]; # IntelliJ Idea dirs
      userEmail = "florian.peter@gmx.at";
      userName = "workflow";
    };

    htop.enable = true;

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

    parcellite.enable = true;

    syncthing = {
      enable = true;
    };

    udiskie.enable = true;

    unclutter.enable = true;
  };

}
