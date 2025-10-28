# Cursor style AI IDE
{
  isImpermanent,
  lib,
  pkgs,
  ...
}: {
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
    plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = avante-nvim;
        config = builtins.readFile ./avante.lua;
        type = "lua";
      }
    ];
  };
}
