require("neotest").setup({
  adapters = {
    require("neotest-rust") {
    },
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
    { "<leader>no", require("neotest").output_panel.toggle,                          desc = "Toggle [O]utput Panel" },
    { "<leader>ns", require("neotest").summary.toggle,                               desc = "Toggle [S]ummary" },
  }
)
