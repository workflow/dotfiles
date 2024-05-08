local function ts_disable_long_files(_, bufnr)
  return vim.api.nvim_buf_line_count(bufnr) > 5000
end

local disabled_languages = {
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
        node_decremental = '<c-M-s>',
      },
    },
  }
end, 0)
