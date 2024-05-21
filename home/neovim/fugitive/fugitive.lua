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
wk.register({
	g = {
		name = "[G]it",
		b = { ":Git checkout -b<Space>", "New [b]ranch" },
		B = { ":Git blame<CR>", "[B]lame" },
		c = { ":Git checkout<Space>", "[C]heckout branch/tag" },
		d = {
			name = "[D]iff",
			d = { ":Gdiff<CR>", "[D]iff" },
			s = { ":Gdiffsplit!<CR>", "[S]plit diff" },
		},
		e = { ":Gedit", "Ch[e]ckout any branch/sha/file" },
		h = { ":0Gclog<CR>", "[H]istory for entire file" },
		l = { ":Gclog<CR>", "[L]og" },
		m = { ":GMove<Space>", "[M]ove" },
		r = { ":Gread<CR>", "[R]evert to working tree/index copy of file" },
		w = { ":Gwrite<CR>", "[W]rite to index" },
		p = {
			name = "[P]ush/pull",
			f = { function()
				vim.cmd(
					'TermExec cmd="git push --force-with-lease" | call fugitive#ReloadStatus()')
			end, "[F]orce push with lease" },
			l = { function() vim.cmd('TermExec cmd="git pull" | call fugitive#ReloadStatus()') end, "[P]ull" },
			n = { function() vim.cmd('TermExec cmd="git push -u origin HEAD" | call fugitive#ReloadStatus()') end, "Push [n]ew branch" },
			s = { function() vim.cmd('TermExec cmd="git push" | call fugitive#ReloadStatus()') end, "Pu[s]h" },
		}
	},
	-- TODO: provide these to Fugitive diff buffers only
	-- nnoremap gj :diffget //2<CR>
	-- nnoremap gl :diffget //3<CR>
}, { prefix = "<leader>", silent = false })

wk.register({
	g = {
		name = "[G]it",
		h = { ":Gclog<CR>", "[H]istory for selection" },
	},
}, { prefix = "<leader>", mode = "v" })
