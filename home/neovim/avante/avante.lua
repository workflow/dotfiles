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
	claude = {
		endpoint = "https://api.anthropic.com",
		model = "claude-3-7-sonnet-20250219",
		temperature = 0,
		max_tokens = 8192,
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
