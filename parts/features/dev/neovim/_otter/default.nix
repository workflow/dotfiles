{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = otter-nvim;
      config = ''
        require('otter').setup({
          lsp = {
            hover = {
              -- Border style for LSP hover windows in embedded code
              border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            },
          },
        })

        local wk = require("which-key")
        wk.add({
          { "<leader>O", group = "[O]tter" },
          { "<leader>Oa", function() require("otter").activate() end, desc = "[A]ctivate Otter" },
          { "<leader>Od", function() require("otter").deactivate() end, desc = "[D]eactivate Otter" },
        })
      '';
      type = "lua";
    }
  ];
}
