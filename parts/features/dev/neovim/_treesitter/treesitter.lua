local function ts_disable_long_files(_, bufnr)
  return vim.api.nvim_buf_line_count(bufnr) > 5000
end

local disabled_languages = {
  "csv", -- In favor of rainbow-csv-nvim
}

-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    auto_install = false,
    highlight = {
      enable = true,
      disable = function(lang, bufnr)
        return vim.tbl_contains(disabled_languages, lang) or ts_disable_long_files(lang, bufnr)
      end,
    },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-s>',
        node_incremental = '<c-s>',
        scope_incremental = false, -- Disable to avoid 'grc' conflict with mini.operators
        node_decremental = '<c-M-s>',
      },
    },
  }

  -- Add additional intuitive keybindings for treesitter selection
  -- These complement the <c-s> bindings and work in visual mode
  vim.keymap.set('x', '+', function()
    require('nvim-treesitter.incremental_selection').node_incremental()
  end, { desc = 'Treesitter: Expand selection' })

  vim.keymap.set('x', '_', function()
    require('nvim-treesitter.incremental_selection').node_decremental()
  end, { desc = 'Treesitter: Shrink selection' })

  -- Document the keybindings with which-key
  local wk = require("which-key")
  wk.add({
    { "<c-s>", desc = "Treesitter: Init/Expand selection", mode = {"n", "x"} },
    { "<c-M-s>", desc = "Treesitter: Shrink selection", mode = "x" },
    { "+", desc = "Treesitter: Expand selection", mode = "x" },
    { "_", desc = "Treesitter: Shrink selection", mode = "x" },
  })
end, 0)
