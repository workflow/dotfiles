require('overseer').setup({
  strategy = "toggleterm",
  templates = {
    "builtin",
    "user.gmailctl_apply",
    "user.java_gradle",
    "user.java_maven",
    "user.nixos_rebuild_switch",
    "user.nixos_rebuild_boot",
    "user.nixos_update_secrets",
    "user.skaffold_dev",
  },
})
local wk = require("which-key")
wk.add(
  {
    { "<leader>o",  group = "[O]verseer" },
    { "<leader>or", "<cmd>OverseerRun<CR>",    desc = "[R]un" },
    { "<leader>ot", "<cmd>OverseerToggle<CR>", desc = "[T]oggle List" },
  }
)
