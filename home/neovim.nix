{ pkgs, ... }:
let
  nixpkgs-vimplugins-vim-textobj-entire = import sources.nixpkgs-vimplugins-vim-textobj-entire { config.allowUnfree = true; };

  sources = import ../nix/sources.nix;

in
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
      noremap h ;
      noremap <C-w>; <C-w>l
      noremap <C-w>l <C-w>k
      noremap <C-w>k <C-w>j
      noremap <C-w>j <C-w>h

      set shell=/run/current-system/sw/bin/bash

      let mapleader = ' '

      colorscheme one
      let g:one_allow_italics = 1

      " COC Settings
      nnoremap <silent> <leader>h :call CocActionAsync('doHover')<cr>
    '';

    plugins = with pkgs.vimPlugins; [
      argtextobj-vim

      coc-nvim
      coc-tsserver
      coc-json
      coc-html
      coc-css
      coc-prettier

      vim-commentary
      elm-vim
      vim-exchange
      vim-highlightedyank
      vim-nix
      vim-one # Colorscheme
      ReplaceWithRegister
      vim-solidity
      vim-startify

      nixpkgs-vimplugins-vim-textobj-entire.vimPlugins.vim-textobj-entire
    ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
