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

          local wk = require("which-key")
          wk.add({
            { "<leader>nh", "<cmd>Telescope notify<CR>", desc = "Notification [H]istory" },
          })
        '';
        type = "lua";
      }
    ];
  };
}
