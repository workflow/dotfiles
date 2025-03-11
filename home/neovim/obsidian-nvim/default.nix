{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = obsidian-nvim;
      config = ''
        require("obsidian").setup({
          workspaces = {
            {
              name = "main",
              path = "~/Obsidian",
            }
          },
        })

        local wk = require("which-key")
        wk.add({
          { "<leader><leader>o", "<cmd>ObsidianSearch<cr>", desc = "Search [O]bsidian" },
        })
      '';
      type = "lua";
    }
  ];
}
