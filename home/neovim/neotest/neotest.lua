require("neotest").setup({
  adapters = {
    -- require("neotest-java"),
    require("neotest-vim-test")({
      -- ignore_file_types = { "java" },
    }),
  },
})

local wk = require("which-key")
wk.add(
  {
    { "<leader>n",  group = "[N]eotest" },
    { "<leader>na", require("neotest").run.attach,                                   desc = "[A]ttach to nearest" },
    { "<leader>nd", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "[D]ebug nearest" },
    { "<leader>nf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "[F]ile" },
    { "<leader>nn", require("neotest").run.run,                                      desc = "[N]earest" },
    { "<leader>ns", require("neotest").run.stop,                                     desc = "[S]top nearest" },
  }
)
