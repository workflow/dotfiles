local wk = require("which-key")
require("dapui").setup({
  wk.register({
    d = {
      t = { require('dapui').toggle, "[T]oggle UI" },
    },
  }, { prefix = "<leader>" })
})
