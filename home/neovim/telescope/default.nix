{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = telescope-nvim;
      config = ''
        local builtin = require("telescope.builtin")
        local utils = require("telescope.utils")
        require("telescope").setup({
          defaults = {
            mappings = {
              i = {
                ["<C-s>"] = require("telescope.actions").select_horizontal,
              },
              n = {
                ["<C-s>"] = require("telescope.actions").select_horizontal,
              },
            },
          },
          pickers = {
            find_files = {
              hidden = true,
            },
          },
        })
        require("telescope").load_extension("fzf")
        local wk = require("which-key")
        wk.add(
          {
            { "<leader><space>", group = "Find[ ](Telescope)" },
            { "<leader><space>.", function() builtin.find_files({ cwd = utils.buffer_dir() }) end, desc = "Files in CWD" },
            { "<leader><space><space>", "<cmd>Telescope git_files<CR>", desc = "Version Controlled Files" },
            { "<leader><space>?", "<cmd>Telescope keymaps<CR>", desc = "Vim Keymap Cheatsheet" },
            { "<leader><space>b", "<cmd>Telescope buffers<CR>", desc = "[B]uffers" },
            { "<leader><space>c", "<cmd>Telescope commands<CR>", desc = "[C]ommands" },
            { "<leader><space>d", "<cmd>Telescope command_history<CR>", desc = "Comman[d] History" },
            { "<leader><space>e", "<cmd>Telescope help_tags<CR>", desc = "H[e]lp Tags" },
            { "<leader><space>f", "<cmd>Telescope find_files<CR>", desc = "All [F]iles" },
            { "<leader><space>g", "<cmd>Telescope live_grep<CR>", desc = "[G]rep" },
            { "<leader><space>m", "<cmd>Telescope bookmarks list<CR>", desc = "Book[m]arks" },
          }
        )
      '';
      type = "lua";
    }
    {
      plugin = telescope-fzf-native-nvim;
    }
    {
      plugin = telescope-frecency-nvim;
      config = ''
        require("telescope").setup({
          extensions = {
            frecency = {
              show_scores = true,
              auto_validate = false, -- manually gc with :FrecencyValidate
            },
          },
        })
        require("telescope").load_extension("frecency")
        local wk = require("which-key")
        wk.add(
          {
            { "<leader><space>h", "<Cmd>Telescope frecency workspace=CWD<CR>", desc = "History (Frecency)" },
          }
        )
      '';
      type = "lua";
    }
    {
      plugin = telescope-undo-nvim;
      config = ''
        require("telescope").setup({
          extensions = {
            undo = {};
          },
        })
        require("telescope").load_extension("undo")
        local wk = require("which-key")
        wk.add(
          {
            { "<leader>u", "<cmd>Telescope undo<cr>", desc = "[U]ndo Tree" },
          }
        )
      '';
      type = "lua";
    }
  ];
}
