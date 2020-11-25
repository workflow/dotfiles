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
      noremap <C-w>; <C-w>l
      noremap <C-w>l <C-w>k
      noremap <C-w>k <C-w>j
      noremap <C-w>j <C-w>h

      set shell=/run/current-system/sw/bin/bash

      let mapleader = ' '

      colorscheme one
      let g:one_allow_italics = 1
      set background=dark

      nnoremap <leader>' :call LanguageClient_contextMenu()<CR>
    '';

    plugins = [
      pkgs.vimPlugins.vim-highlightedyank
      pkgs.vimPlugins.vim-nix
      pkgs.vimPlugins.vim-one # Colorscheme
      pkgs.vimPlugins.vim-solidity
      pkgs.vimPlugins.vim-startify
      pkgs.vimPlugins.vim-commentary
      pkgs.vimPlugins.ReplaceWithRegister
      pkgs.vimPlugins.argtextobj-vim
      pkgs.vimPlugins.vim-exchange

      pkgs.vimPlugins.coc-nvim
      pkgs.vimPlugins.coc-tsserver
      pkgs.vimPlugins.coc-json
      pkgs.vimPlugins.coc-html
      pkgs.vimPlugins.coc-css
      pkgs.vimPlugins.coc-prettier

      nixpkgs-vimplugins-vim-textobj-entire.vimPlugins.vim-textobj-entire
    ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
