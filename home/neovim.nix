{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    extraConfig = ''
      set number
      set clipboard=unnamedplus

      noremap ; l
      noremap l k
      noremap k j
      noremap j h

      set shell=/run/current-system/sw/bin/bash
    '';

    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-solidity
    ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
