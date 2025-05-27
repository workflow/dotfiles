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
        -- Autoclose, see https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
        local function tab_win_closed(winnr)
          local api = require"nvim-tree.api"
          local tabnr = vim.api.nvim_win_get_tabpage(winnr)
          local bufnr = vim.api.nvim_win_get_buf(winnr)
          local buf_info = vim.fn.getbufinfo(bufnr)[1]
          local tab_wins = vim.tbl_filter(function(w) return w~=winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
          local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
          if buf_info.name:match(".*NvimTree_%d*$") then            -- close buffer was nvim tree
            -- Close all nvim tree on :q
            if not vim.tbl_isempty(tab_bufs) then                      -- and was not the last window (not closed automatically by code below)
              api.tree.close()
            end
          else                                                      -- else closed buffer was normal buffer
            if #tab_bufs == 1 then                                    -- if there is only 1 buffer left in the tab
              local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
              if last_buf_info.name:match(".*NvimTree_%d*$") then       -- and that buffer is nvim tree
                vim.schedule(function ()
                  if #vim.api.nvim_list_wins() == 1 then                -- if its the last buffer in vim
                    vim.cmd "quit"                                        -- then close all of vim
                  else                                                  -- else there are more tabs open
                    vim.api.nvim_win_close(tab_wins[1], true)             -- then close only the tab
                  end
                end)
              end
            end
          end
        end
        vim.api.nvim_create_autocmd("WinClosed", {
          callback = function ()
            local winnr = tonumber(vim.fn.expand("<amatch>"))
            vim.schedule_wrap(tab_win_closed(winnr))
          end,
          nested = true
        })
      '';
      type = "lua";
    }
  ];
}
