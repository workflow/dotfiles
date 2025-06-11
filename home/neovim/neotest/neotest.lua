require("neotest").setup({
  adapters = {
    require("neotest-rust") {
    },
  },
  consumers = {
    overseer = require("neotest.consumers.overseer"),
  },
})

local wk = require("which-key")
wk.add(
  {
    { "<leader>t",  group = "neo[T]est" },
    { "<leader>ta", require("neotest").run.attach,                                   desc = "[A]ttach to nearest" },
    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "[D]ebug nearest" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "[F]ile" },
    { "<leader>tn", require("neotest").run.run,                                      desc = "[N]earest" },
    {
      "<leader>to",
      function()
        require("neotest").output_panel.toggle()
        vim.cmd("wincmd p")
      end,
      desc = "Toggle [O]utput Panel"
    },
    { "<leader>ts", function() require("neotest").summary.toggle({ enter = true }) end, desc = "Toggle [S]ummary" },
  }
)
