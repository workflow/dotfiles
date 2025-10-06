require('avante_lib').load()
require('avante').setup({
	behaviour = {
		enable_fastapply = true, -- Uses morphllm.com
		auto_approve_tool_permissions = false,
	},
	debug = false,
	dual_boost = {
		enabled = false,
		first_provider = "azure",
	},
	hints = { enabled = false },
	instructions_file = "agents.md",
	providers = {
		openai = {
			model = "gpt-5",
			extra_request_body = {
				temperature = 1,
			},
		},
		openai_5_thinking = {
			__inherited_from = 'openai',
			model = "gpt-5",
			extra_request_body = {
				temperature = 1,
				reasoning_effort = "high",
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
			model = "claude-sonnet-4-5",
		},
		claude_thinking = {
			__inherited_from = 'claude',
			model = "claude-sonnet-4-5",
			thinking = {
				type = "enabled",
			},
		},
		copilot = {
			model = "gpt-5",
		},
		copilot_claude = {
			__inherited_from = 'copilot',
			model = "claude-sonnet-4.5",
		},
		copilot_gemini = {
			__inherited_from = 'copilot',
			model = "gemini-2.5-pro",
		},
		copilot_gpt5_high = {
			__inherited_from = 'copilot',
			model = "gpt-5",
			extra_request_body = {
				reasoning_effort = "high",
			},
		},
		morph = {
			model = "auto",
		},
	},
	provider = "copilot",
	selector = {
		provider = "telescope",
		exclude_auto_select = { "NvimTree" },
	},
	system_prompt =
	"Do not directly run system commands to verify task success at the end, ask the user to run them and provide output. When writing to AGENTS.md, don't document history, only note architectural changes that would be important to know going forward. Do not offer to git commit or push changes. When writing shell scripts, always prefer the longhand version of arguments (e.g., --all instead of -a) and reserve the short-hand version for ad-hoc command invocations.",

	web_search_engine = {
		provider = "kagi",
	},
})

-- Improve contrast for Avante diffs when using a light colorscheme (e.g., gruvbox-light)
-- This specifically targets deleted lines which tend to have very low contrast.
local function set_avante_light_highlights()
	if vim.o.background ~= 'light' then return end

	-- Make deleted lines readable on light background
	-- Use a stronger red background and high-contrast foreground
	vim.api.nvim_set_hl(0, 'DiffDelete', { fg = '#7c0000', bg = '#ffb4b4', bold = true })

	-- Ensure diff text hunk highlight is also visible enough on light backgrounds
	vim.api.nvim_set_hl(0, 'DiffText', { bg = '#ffe29a' })

	-- Avante-specific groups that can appear for deleted blocks in edit/suggestion views
	pcall(vim.api.nvim_set_hl, 0, 'AvanteToBeDeleted',
		{ fg = '#7c0000', bg = '#ffb4b4', strikethrough = true, bold = true })
	pcall(vim.api.nvim_set_hl, 0, 'AvanteToBeDeletedWOStrikethrough', { fg = '#ffffff', bg = '#a23a3f', bold = true })

	-- Avante exposes highlight groups for conflicts; set them to readable backgrounds if present
	-- Use pcall so this doesn't error if groups don't exist or are managed by the plugin
	pcall(vim.api.nvim_set_hl, 0, 'AvanteConflictCurrent', { bg = '#ffe8b3' }) -- ours/current
	pcall(vim.api.nvim_set_hl, 0, 'AvanteConflictIncoming', { bg = '#d9f2d9' }) -- theirs/incoming
end

-- Apply immediately and re-apply when colorscheme or background changes
set_avante_light_highlights()
vim.api.nvim_create_autocmd('ColorScheme', {
	callback = set_avante_light_highlights,
})
vim.api.nvim_create_autocmd('OptionSet', {
	pattern = 'background',
	callback = set_avante_light_highlights,
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

-- Set up buffer-local mappings for NvimTree
vim.api.nvim_create_autocmd("FileType", {
	pattern = "NvimTree",
	callback = function(args)
		local bufnr = args.buf
		vim.keymap.set("n", "<leader>a+", function()
			local tree_ext = require("avante.extensions.nvim_tree")
			tree_ext.add_file()
		end, { buffer = bufnr, desc = "Select file in NvimTree" })

		vim.keymap.set("n", "<leader>a-", function()
			local tree_ext = require("avante.extensions.nvim_tree")
			tree_ext.remove_file()
		end, { buffer = bufnr, desc = "Deselect file in NvimTree" })
	end,
})
