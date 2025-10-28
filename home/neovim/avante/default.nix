# Cursor style AI IDE
{
  isImpermanent,
  lib,
  pkgs,
  ...
}: let
  # Pin avante-nvim to 0.0.27-unstable-2025-10-06, with the next version introducing lots of bugs like broken history and hangs.
  pinnedNixpkgs = pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "bce5fe2bb998488d8e7e7856315f90496723793c";
    sha256 = "sha256-vwXL9H5zDHEQA0oFpww2one0/hkwnPAjc47LRph6d0I=";
  };
  pinnedPkgs = import pinnedNixpkgs {
    system = pkgs.system;
    config = pkgs.config;
  };
in {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/avante.nvim" # Some Avante state like last used model
    ];
  };
  programs.neovim = {
    extraLuaConfig = ''
      -- views can only be fully collapsed with the global statusline
      vim.opt.laststatus = 3
    '';
    plugins = [
      {
        plugin = pinnedPkgs.vimPlugins.avante-nvim;
        config = builtins.readFile ./avante.lua;
        type = "lua";
      }
    ];
  };
}
