require('overseer').setup({
  strategy = "toggleterm",
  templates = {
    "builtin",
    "user.gmailctl_apply",
    "user.java_gradle",
    "user.java_maven",
    "user.nixos_rebuild_switch",
    "user.nixos_update_secrets",
    "user.skaffold_dev",
  },
})
local wk = require("which-key")
wk.register({
  o = {
    name = "[O]verseer",
    r = { "<cmd>OverseerRun<CR>", "[R]un" },
    t = { "<cmd>OverseerToggle<CR>", "[T]oggle List" },
  },
}, { prefix = "<leader>" })
