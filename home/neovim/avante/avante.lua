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
	hints = { enabled = false },
	web_search_engine = {
		provider = "kagi",
	},
})
local wk = require("which-key")
wk.add(
	{
		{
			{ "<leader>a", group = "[A]vante" },
			{ "<F1>",      "<cmd>AvanteToggle<cr>",      desc = "Toggle Avante", mode = { "n", "v" } },
			{ "<F1>",      "<esc><cmd>AvanteToggle<cr>", desc = "Toggle Avante", mode = { "i" } },
		},
	}
)
