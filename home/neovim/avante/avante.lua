require('avante_lib').load()
require('avante').setup({
	debug = false,
	dual_boost = {
		enabled = false,
		first_provider = "azure",
	},
	providers = {
		openai = {
			model = "gpt-5",
			extra_request_body = {
				temperature = 1,
			},
		},
		openai_4_1 = {
			__inherited_from = 'openai',
			model = "gpt-4.1",
		},
		openai_o4_mini_high = {
			__inherited_from = 'openai',
			model = "o4-mini",
			extra_request_body = {
				reasoning_effort = "high",
			},
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
			model = "gpt-5",
		},
		copilot_claude = {
			__inherited_from = 'copilot',
			model = "claude-sonnet-4",
		},
		copilot_gemini = {
			__inherited_from = 'copilot',
			model = "gemini-2.5-pro",
		},
		copilot_o4_mini_high = {
			__inherited_from = 'copilot',
			model = "o4-mini",
			extra_request_body = {
				reasoning_effort = "high",
			},
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
