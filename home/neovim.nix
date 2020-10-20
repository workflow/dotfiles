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

      let mapleader = ' '

      colorscheme one
      let g:one_allow_italics = 1
      set background=dark
    '';

    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-one # Colorscheme
      vim-solidity
      vim-startify
    ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
