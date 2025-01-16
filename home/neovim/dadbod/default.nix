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
        wk.add(
          {
            { "<leader>D", group = "[D]atabase" },
            { "<leader>Dn", "<cmd>tab DBUI<CR>", desc = "open in [n]ew tab" },
            { "<leader>Dt", "<cmd>DBUIToggle<CR>", desc = "[t]oggle" },
          }
        )
      '';
      type = "lua";
    }
  ];
}
