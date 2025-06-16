{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = nvim-tree-lua;
      config = ''
        local function my_on_attach(bufnr)
          local api = require "nvim-tree.api"
          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end
          -- default mappings
          api.config.mappings.default_on_attach(bufnr)
          -- custom mappings
          vim.keymap.set('n', '<C-s>', api.node.open.horizontal, opts('Open: Horizontal Split'))
          vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
        end
        require("nvim-tree").setup({
          on_attach = my_on_attach,
          disable_netrw = false, -- keeping netrw for :GBrowse from fugitive to work
          hijack_netrw = true, -- once no longer needed, check :he nvim-tree-netrw
          -- Dynamic width
          view = {
            width = {
              min = 30,
              max = -1,
            },
          },
        })
        local wk = require("which-key")
        wk.add(
          {
            { "<leader>f", group = "[F]iles(NvimTree)" },
            { "<leader>fc", "<cmd>NvimTreeCollapse<CR>", desc = "[C]ollapse NVimTree Node Recursively" },
            { "<leader>ff", "<cmd>NvimTreeFindFile<CR>", desc = "Move the cursor in the tree for the current buffer, opening [f]olders if needed." },
            { "<leader>ft", "<cmd>NvimTreeToggle<CR>", desc = "[T]oggle NvimTree" },
            { "<F2>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree", mode = { "n", "v" } },
            { "<F2>", "<esc><cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree", mode = { "i" } },
          }
        )
      '';
      type = "lua";
    }
  ];
}
