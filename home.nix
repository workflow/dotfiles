{ config, lib, pkgs, ... }:

let 

  fishrc = pkgs.callPackage ./dotfiles/fishrc.nix {};
  profile = pkgs.callPackage ./dotfiles/profile.nix {};

  imports = [
    ./home/i3.nix
    ./home/rofi.nix
  ];

in

{

  home = {
    file = {
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

  programs.bat.enable = true;

  programs.chromium = {
    enable = true;
    extensions = [];
  };

  programs.firefox = {
    enable = true;
    #enableIcedTea = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = fishrc.shellInit;
    functions = fishrc.functions;
    plugins = fishrc.plugins;
    shellAbbrs = profile.aliases;
  };

  programs.git = {
    enable = true;
    ignores = [ ".idea" ]; # IntelliJ Idea dirs
    userEmail = "florian.peter@gmx.at";
    userName = "workflow";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.htop.enable = true;

  programs.neovim = {
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

  programs.ssh = {
    enable = true;
  };

  programs.tmux = {
    enable = true;

    # Reduce escape time to 10ms, otherwise VIM <esc> is slooooow
    escapeTime = 10;

    extraConfig = pkgs.callPackage ./dotfiles/tmux-conf.nix { };

    historyLimit = 20000;

    shortcut = "w";

  };

  services.flameshot.enable = true; 

  services.parcellite.enable = true;

  services.syncthing = {
    enable = true;
    tray = true;
  };

}
