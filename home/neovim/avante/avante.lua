require('avante_lib').load()
require('avante').setup({
	dual_boost = {
		enabled = true,
	},
	hints = { enabled = false }
})
local wk = require("which-key")
wk.add(
	{
		{
			{ "<leader>a", group = "[A]vante" },
		},
	}
)
