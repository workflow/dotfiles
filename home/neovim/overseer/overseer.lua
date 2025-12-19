require('overseer').setup({
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
  component_aliases = {
    default = {
      "on_exit_set_status",
      "on_complete_notify",
      { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
      { "open_output", direction = "dock", on_start = "always", focus = true },
    },
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
