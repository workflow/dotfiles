{ pkgs, ... }:
{
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
}
