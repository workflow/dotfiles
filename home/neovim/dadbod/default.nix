{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = vim-dadbod; # SQL Fu
    }
    {
      plugin = vim-dadbod-completion;
    }
    {
      plugin = vim-dadbod-ui;
      config = ''
        vim.g.db_ui_use_nerd_fonts = 1

        local wk = require("which-key")
        wk.register({
          ["<leader>"] = {
            D = {
              name = "[D]atabase",
              t = { "<cmd>DBUIToggle<CR>", "[t]oggle" },
              n = { "<cmd>tab DBUI<CR>", "open in [n]ew tab" },
            },
          },
        })
      '';
      type = "lua";
    }
  ];
}
