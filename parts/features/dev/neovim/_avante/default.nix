# Cursor style AI IDE
{
  lib,
  pkgs,
  osConfig,
  ...
}: {
  home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
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
        plugin = pkgs.vimPlugins.avante-nvim;
        config = builtins.readFile ./avante.lua;
        type = "lua";
      }
    ];
  };
}
