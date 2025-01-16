require("chatgpt").setup({
	openai_params = {
		model = "gpt-4-turbo",
		frequency_penalty = 0,
		presence_penalty = 0,
		max_tokens = 800,
		temperature = 0,
		top_p = 1,
		n = 1,
	},
	openai_edit_params = {
		model = "gpt-4-turbo",
		temperature = 0,
		top_p = 1,
		n = 1,
	},
	popup_input = {
		submit = "<C-s>"
	},
	edit_with_instructions = {
		keymaps = {
			toggle_help = "<C-h>",
			use_output_as_input = "<C-x>",
		}
	},

})
local wk = require("which-key")
wk.add(
	{
		{ "<leader>c",  group = "[C]hatGPT" },
		{ "<leader>cc", "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
		{
			mode = { "n", "v" },
			{ "<leader>ca", "<cmd>ChatGPTRun add_tests<CR>",                 desc = "Add Tests" },
			{ "<leader>cd", "<cmd>ChatGPTRun docstring<CR>",                 desc = "Docstring" },
			{ "<leader>ce", "<cmd>ChatGPTEditWithInstruction<CR>",           desc = "Edit with instruction" },
			{ "<leader>cf", "<cmd>ChatGPTRun fix_bugs<CR>",                  desc = "Fix Bugs" },
			{ "<leader>cg", "<cmd>ChatGPTRun grammar_correction<CR>",        desc = "Grammar Correction" },
			{ "<leader>ck", "<cmd>ChatGPTRun keywords<CR>",                  desc = "Keywords" },
			{ "<leader>cl", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis" },
			{ "<leader>co", "<cmd>ChatGPTRun optimize_code<CR>",             desc = "Optimize Code" },
			{ "<leader>cr", "<cmd>ChatGPTRun roxygen_edit<CR>",              desc = "Roxygen Edit" },
			{ "<leader>cs", "<cmd>ChatGPTRun summarize<CR>",                 desc = "Summarize" },
			{ "<leader>ct", "<cmd>ChatGPTRun translate<CR>",                 desc = "Translate" },
			{ "<leader>cx", "<cmd>ChatGPTRun explain_code<CR>",              desc = "Explain Code" },
		},
	}
)
