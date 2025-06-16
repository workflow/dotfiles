require("noice").setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		bottom_search = true,   -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false,     -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},
})

-- Cmdline auto-accept tweaks
vim.keymap.set("c", "<CR>", function()
	if require("noice").api.cmdline.is_active() then
		-- Check if there's a completion visible
		if vim.fn.pumvisible() == 1 then
			return "<C-y>" -- Accept completion
		else
			return "<CR>" -- Normal enter
		end
	else
		return "<CR>"
	end
end, { expr = true })
-- And map Ctrl+Enter for directly executing cmdline without completion
vim.keymap.set("c", "<C-CR>", "<CR>", { expr = false })

local wk = require("which-key")
wk.add(
	{
		{ "<leader>n",  group = "[N]oice" },
		{ "<leader>nd", "<cmd>NoiceDismiss<CR>", desc = "[D]ismiss Notifications" },
		{ "<leader>nl", "<cmd>NoiceLast<CR>",    desc = "[L]ast Notifiation" },
		{ "<leader>nn", "<cmd>Noice<CR>",        desc = "Show all [N]otifications" },
	}
)
