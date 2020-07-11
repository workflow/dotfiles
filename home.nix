{ config, lib, pkgs, ... }:

let 

  sources = import ./nix/sources.nix;
  nixpkgs-unstable = import sources.nixpkgs-unstable { config.allowUnfree = true; };

  fishrc = pkgs.callPackage ./dotfiles/fishrc.nix {};
  profile = pkgs.callPackage ./dotfiles/profile.nix {};
  scripts = pkgs.callPackage ./dotfiles/scripts.nix { inherit nixpkgs-unstable; };

  imports = [
    ./home/i3.nix
    ./home/rofi.nix
  ];

in

{

  home = {
    file = {
      # ~/bin
      # Declaratively configure Mega backups
      "bin/configure-mega-backup" = { text = scripts.configure-mega-backup; executable = true; };

      # Syncthing
      ".config/syncthing/config.xml".source = ./dotfiles/syncthing.xml;
      "code/.stignore".source = ./dotfiles/stignore_code;
      ".ssh/.stignore".source = ./dotfiles/stignore_ssh;
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
      name = "Inconsolata 10";
      package = pkgs.google-fonts;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs = {
    bat.enable = true;

    chromium = {
      enable = true;
      extensions = [];
    };

    firefox = {
      enable = true;
      #enableIcedTea = true;
    };

    fish = {
      enable = true;
      interactiveShellInit = fishrc.shellInit;
      functions = fishrc.functions;
      plugins = fishrc.plugins;
      shellAbbrs = profile.aliases;
    };

    git = {
      enable = true;
      ignores = [ ".idea" ]; # IntelliJ Idea dirs
      userEmail = "florian.peter@gmx.at";
      userName = "workflow";
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    htop.enable = true;

    neovim = {
      enable = true;

      extraConfig = ''
        set number
        set clipboard=unnamedplus
      '';

      plugins = with pkgs.vimPlugins; [
        vim-nix
      ];

      vimAlias = true;
    };

    ssh = {
      enable = true;
    };

    tmux = {
      enable = true;

      # Reduce escape time to 10ms, otherwise VIM <esc> is slooooow
      escapeTime = 10;

      extraConfig = pkgs.callPackage ./dotfiles/tmux-conf.nix { };

      historyLimit = 20000;

      shortcut = "w";

    };
  };

  services = {
    flameshot.enable = true; 

    parcellite.enable = true;

    syncthing = {
      enable = true;
      tray = true;
    };
  };

}
