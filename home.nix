{ config, lib, pkgs, ... }:

{
  services.parcellite.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
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
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-nix
    ];
    
  };

  programs.ssh = {
    enable = true;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";
}
