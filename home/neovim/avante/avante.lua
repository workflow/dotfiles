require('avante_lib').load()
require('avante').setup({
	azure = {
		endpoint = "https://hl-openai-sweden.openai.azure.com",
		deployment = "gpt-4o",
		api_version = "2024-10-21",
	},
	dual_boost = {
		enabled = true,
		first_provider = "azure",
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
