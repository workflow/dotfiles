-- Ensure mini.icons mock is active before configuring nvim-tree
local ok_icons, Icons = pcall(require, 'mini.icons')
if ok_icons and Icons and Icons.mock_nvim_web_devicons then
  -- Replace nvim-web-devicons so nvim-tree and others use mini.icons
  pcall(Icons.mock_nvim_web_devicons)
end

local function my_on_attach(bufnr)
	local api = require "nvim-tree.api"
	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end
	-- default mappings
	api.config.mappings.default_on_attach(bufnr)
	-- custom mappings
	vim.keymap.set('n', '<C-s>', api.node.open.horizontal, opts('Open: Horizontal Split'))
	vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
end
require("nvim-tree").setup({
	on_attach = my_on_attach,
	disable_netrw = false, -- keeping netrw for :GBrowse from fugitive to work
	hijack_netrw = true, -- once no longer needed, check :he nvim-tree-netrw
	-- Ensure devicons are enabled so the mini.icons mock is used
	renderer = {
		icons = {
			-- Use simple ASCII for folder glyphs to avoid NF v2/v3 codepoint mismatches
			glyphs = {
				folder = {
					arrow_closed = "",
					arrow_open = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
			},
		},
	},
	-- Dynamic width
	view = {
		width = {
			min = 30,
			max = -1,
		},
	},
})
local wk = require("which-key")
wk.add(
	{
		{ "<leader>f",  group = "[F]iles(NvimTree)" },
		{ "<leader>fc", "<cmd>NvimTreeCollapse<CR>",    desc = "[C]ollapse NVimTree Node Recursively" },
		{ "<leader>ff", "<cmd>NvimTreeFindFile<CR>",    desc = "Move the cursor in the tree for the current buffer, opening [f]olders if needed." },
		{ "<leader>ft", "<cmd>NvimTreeToggle<CR>",      desc = "[T]oggle NvimTree" },
		{ "<F2>",       "<cmd>NvimTreeToggle<CR>",      desc = "Toggle NvimTree",                                                                 mode = { "n", "v" } },
		{ "<F2>",       "<esc><cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree",                                                                 mode = { "i" } },
	}
)
