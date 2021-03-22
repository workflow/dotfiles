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
      let maplocalleader = ' '

      colorscheme one
      let g:one_allow_italics = 1

      " COC Settings
      nnoremap <silent> <leader>h :call CocActionAsync('doHover')<cr>

      " FZF Settings
      nnoremap <C-p> :GFiles<cr>

      " Open up a simple file tree
      nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
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
      fzf-vim
      vim-highlightedyank
      vim-nix
      vim-numbertoggle
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
