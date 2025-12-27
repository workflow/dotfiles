local wk = require("which-key")
wk.add({
  { "<leader>v",  group = "Diff[v]iew" },
  { "<leader>vo", ":DiffviewOpen<CR>",          desc = "[O]pen" },
  { "<leader>vh", ":DiffviewFileHistory %<CR>", desc = "File [h]istory" },
  { "<leader>vH", ":DiffviewFileHistory .<CR>", desc = "Directory [H]istory" },
  { "<leader>vc", ":DiffviewClose<CR>",         desc = "[C]lose" },
})

require("diffview").setup({
  keymaps = {
    view = {
      { "n", "]c", false },
      { "n", "[c", false },
      { "n", "]x", false },
      { "n", "[x", false },
      { "n", "]l", require("diffview.actions").next_entry, { desc = "Next entry" } },
      { "n", "[l", require("diffview.actions").prev_entry, { desc = "Previous entry" } },
    },
    file_panel = {
      { "n", "j", false },
      { "n", "k", false },
      { "n", "k", require("diffview.actions").next_entry, { desc = "Next entry" } },
      { "n", "l", require("diffview.actions").prev_entry, { desc = "Previous entry" } },
      { "n", "<cr>", require("diffview.actions").select_entry, { desc = "Open diff" } },
    },
    file_history_panel = {
      { "n", "j", false },
      { "n", "k", false },
      { "n", "k", require("diffview.actions").next_entry, { desc = "Next entry" } },
      { "n", "l", require("diffview.actions").prev_entry, { desc = "Previous entry" } },
      { "n", "<cr>", require("diffview.actions").select_entry, { desc = "Open entry" } },
    },
  },
})
