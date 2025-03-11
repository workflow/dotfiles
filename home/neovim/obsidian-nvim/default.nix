{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = obsidian-nvim;
      config = ''
        require("obsidian").setup({
          follow_img_func = function(img)
            vim.fn.jobstart({"xdg-open", url})
          end,
          workspaces = {
            {
              name = "main",
              path = "~/Obsidian",
            }
          },
          -- Clashes with render-markdown.nvim
          ui = {
            enable = false,
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
