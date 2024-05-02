require("neotest").setup({
  adapters = {
    -- require("neotest-java"),
    require("neotest-vim-test")({
      -- ignore_file_types = { "java" },
    }),
  },
})

local wk = require("which-key")
wk.register({
  n = {
    name = "[N]eotest",
    a = { require("neotest").run.attach, "[A]ttach to nearest" },
    d = { function() require("neotest").run.run({ strategy = "dap" }) end, "[D]ebug nearest" },
    f = { function() require("neotest").run.run(vim.fn.expand("%")) end, "[F]ile" },
    n = { require("neotest").run.run, "[N]earest" },
    s = { require("neotest").run.stop, "[S]top nearest" },
  },
}, {
  prefix = "<leader>",
})
