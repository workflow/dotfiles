# Cursor style AI IDE
{pkgs, ...}: {
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
