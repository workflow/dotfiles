local function showFugitiveGit()
	if vim.fn.FugitiveHead() ~= '' then
		vim.cmd [[
            Git
            " wincmd H  " Open Git window in vertical split
            " setlocal winfixwidth
            " vertical resize 31
            " setlocal winfixwidth
            setlocal nonumber
            setlocal norelativenumber
            ]]
	end
end
local function toggleFugitiveGit()
	if vim.fn.buflisted(vim.fn.bufname('fugitive:///*/.git//$')) ~= 0 then
		vim.cmd [[ execute ":bdelete" bufname('fugitive:///*/.git//$') ]]
	else
		showFugitiveGit()
	end
end
vim.keymap.set('n', '<F3>', toggleFugitiveGit)

local wk = require("which-key")
wk.add(
	{
		{ "<leader>g",   group = "[G]it",           silent = false },
		{ "<leader>gB",  ":Git blame<CR>",          desc = "[B]lame",                        silent = false },
		{ "<leader>gb",  ":Git checkout -b<Space>", desc = "New [b]ranch",                   silent = false },
		{ "<leader>gc",  ":Git checkout<Space>",    desc = "[C]heckout branch/tag",          silent = false },
		{ "<leader>gd",  group = "[D]iff",          silent = false },
		{ "<leader>gdd", ":Gdiff<CR>",              desc = "[D]iff",                         silent = false },
		{ "<leader>gds", ":Gdiffsplit!<CR>",        desc = "[S]plit diff",                   silent = false },
		{ "<leader>ge",  ":Gedit",                  desc = "Ch[e]ckout any branch/sha/file", silent = false },
		{ "<leader>gh",  ":0Gclog<CR>",             desc = "[H]istory for entire file",      silent = false },
		{ "<leader>gl",  ":Gclog<CR>",              desc = "[L]og",                          silent = false },
		{ "<leader>gm",  ":GMove<Space>",           desc = "[M]ove",                         silent = false },
		{ "<leader>gp",  group = "[P]ush/pull",     silent = false },
		{
			"<leader>gpf",
			function()
				vim.cmd(
					'TermExec cmd="git push --force-with-lease" | call fugitive#ReloadStatus()')
			end,
			desc = "[F]orce push with lease",
			silent = false
		},
		{ "<leader>gpl", function() vim.cmd('TermExec cmd="git pull" | call fugitive#ReloadStatus()') end, desc = "[P]ull",                                      silent = false },
		{
			"<leader>gpn",
			function()
				vim.cmd(
					'TermExec cmd="git push -u origin HEAD" | call fugitive#ReloadStatus()')
			end,
			desc = "Push [n]ew branch",
			silent = false
		},
		{ "<leader>gps", function() vim.cmd('TermExec cmd="git push" | call fugitive#ReloadStatus()') end, desc = "Pu[s]h",                                      silent = false },
		{ "<leader>gr",  ":Gread<CR>",                                                                     desc = "[R]evert to working tree/index copy of file", silent = false },
		{ "<leader>gw",  ":Gwrite<CR>",                                                                    desc = "[W]rite to index",                            silent = false },
	}
)

wk.add(
	{
		{ "<leader>g",  group = "[G]it", mode = "v" },
		{ "<leader>gh", ":Gclog<CR>",    desc = "[H]istory for selection", mode = "v" },
	}
)


-- Fugitive only mappings
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local bufname = vim.api.nvim_buf_get_name(bufnr)

		if string.match(bufname, "^fugitive://") then
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gj", ":diffget //2<CR>",
				{ noremap = true, silent = false })
			vim.api.nvim_buf_set_keymap(bufnr, "n", "g;", ":diffget //3<CR>",
				{ noremap = true, silent = false })
		end
	end,
})
