local wk = require("which-key")
wk.add(
	{
		{ "<leader>x",  group = "Trouble" },
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                   desc = "Diagnostics",        mode = { "n", "v" } },
		{ "<leader>xx", "<esc><cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics",        mode = { "i" } },
		{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",      desc = "Buffer Diagnostics", mode = { "n", "v" } },
		{ "<leader>xX", "<esc><cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics", mode = { "i" } },
		{ "<leader>xl", "<cmd>Trouble loclist toggle<cr>",                       desc = "[L]ocation List" },
		{ "<leader>xq", "<cmd>Trouble quickfix toggle<cr>",                      desc = "[Q]uickfix" },
		{ "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>",           desc = "[S]ymbols" },
	}
)
require("trouble").setup({
	action_keys = {          -- key mappings for actions in the trouble list
		open_split = { "<c-s>" }, -- open buffer in new split
		open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
		previous = "l",      -- previous item
		next = "k"           -- next item
	},
})
