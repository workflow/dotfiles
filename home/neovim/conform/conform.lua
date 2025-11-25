require("conform").setup({
  formatters_by_ft = {
    sh = { "shfmt" },
    bash = { "shfmt" },
    html = { "prettierd" },
    json = { "prettierd" },
    yaml = { "prettierd" },
    markdown = { "prettierd" },
    python = { "yapf" },
  },
  -- Uncomment to enable format on save:
  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_format = "fallback",
  -- },
})

-- Optional: Set up a keybinding for manual formatting
-- Use <localleader>f since LSP-related actions use localleader
local wk = require("which-key")
wk.add({
  { "<localleader>f", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, desc = "[F]ormat buffer" },
})
