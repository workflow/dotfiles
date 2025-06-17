require('avante_lib').load()
require('avante').setup({
	debug = false,
	dual_boost = {
		enabled = false,
		first_provider = "azure",
	},
	providers = {
		azure = {
			endpoint = "https://hl-openai-sweden.openai.azure.com",
			deployment = "gpt-4.1-mini",
			model = "gpt-4.1-mini",
			api_version = "2025-04-01-preview",
		},
		azure_4_1 = {
			__inherited_from = 'azure',
			model = "gpt-4.1",
			deployment = "gpt-4.1",
		},
		claude = {
			endpoint = "https://api.anthropic.com",
			model = "claude-sonnet-4-20250514",
		},
		claude_thinking = {
			__inherited_from = 'claude',
			model = "claude-sonnet-4-20250514",
			thinking = {
				type = "enabled",
			},
		},
		copilot = {
			model = "claude-sonnet-4",
		},
		copilot_gemini = {
			__inherited_from = 'copilot',
			model = "gemini-2.5-pro",
		},
	},
	hints = { enabled = false },
	provider = "copilot",
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
