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
        wk.register({
          ["<space>"] = {
            name = "Find[ ](Telescope)",
              ["<space>"] = { "<cmd>Telescope git_files<CR>", "Version Controlled Files" },
              b = { "<cmd>Telescope buffers<CR>", "[B]uffers" },
              e = { "<cmd>Telescope help_tags<CR>", "H[e]lp Tags" },
              f = { "<cmd>Telescope find_files<CR>", "All [F]iles" },
              g = { "<cmd>Telescope live_grep<CR>", "[G]rep" },
              m = { "<cmd>Telescope bookmarks list<CR>", "Book[m]arks" },
              ["?"] = { "<cmd>Telescope keymaps<CR>", "Vim Keymap Cheatsheet" },
              ["."] = { function() builtin.find_files({ cwd = utils.buffer_dir() }) end, "Files in CWD" },
            },
        }, { prefix = "<leader>" })
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
        wk.register({
          ["<space>"] = {
            name = "Find[ ](Telescope)",
              h = { "<Cmd>Telescope frecency workspace=CWD<CR>", "History (Frecency)" },
            },
        }, { prefix = "<leader>" })
      '';
      type = "lua";
    }
  ];
}
