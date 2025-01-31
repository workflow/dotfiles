{pkgs, ...}: {
  programs.neovim = {
    extraLuaConfig = ''
      vim.notify = require("notify")
    '';
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-notify;
        config = ''
          require('notify').setup()
        '';
        type = "lua";
      }
    ];
  };
}
