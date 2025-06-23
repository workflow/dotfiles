require('gitsigns').setup {
	on_attach = function(bufnr)
		local gitsigns = require('gitsigns')
		local wk = require("which-key")

		-- Navigation
		vim.keymap.set('n', ']c', function()
			if vim.wo.diff then
				vim.cmd.normal({ ']c', bang = true })
			else
				gitsigns.nav_hunk('next')
			end
		end, { buffer = bufnr, desc = "Next hunk" })

		vim.keymap.set('n', '[c', function()
			if vim.wo.diff then
				vim.cmd.normal({ '[c', bang = true })
			else
				gitsigns.nav_hunk('prev')
			end
		end, { buffer = bufnr, desc = "Previous hunk" })

		-- Text object
		vim.keymap.set({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { buffer = bufnr, desc = "Select hunk" })

		-- Which-key mappings for gitsigns
		wk.add({
			{ "<leader>h", group = "[H]unk", buffer = bufnr },
			{ "<leader>hs", gitsigns.stage_hunk, desc = "[S]tage hunk", buffer = bufnr },
			{ "<leader>hr", gitsigns.reset_hunk, desc = "[R]eset hunk", buffer = bufnr },
			{ "<leader>hS", gitsigns.stage_buffer, desc = "[S]tage buffer", buffer = bufnr },
			{ "<leader>hR", gitsigns.reset_buffer, desc = "[R]eset buffer", buffer = bufnr },
			{ "<leader>hp", gitsigns.preview_hunk, desc = "[P]review hunk", buffer = bufnr },
			{ "<leader>hi", gitsigns.preview_hunk_inline, desc = "Preview hunk [i]nline", buffer = bufnr },
			{ "<leader>hb", function() gitsigns.blame_line({ full = true }) end, desc = "[B]lame line", buffer = bufnr },
			{ "<leader>hd", gitsigns.diffthis, desc = "[D]iff this", buffer = bufnr },
			{ "<leader>hD", function() gitsigns.diffthis('~') end, desc = "[D]iff this ~", buffer = bufnr },
			{ "<leader>hQ", function() gitsigns.setqflist('all') end, desc = "Set [Q]uickfix list (all)", buffer = bufnr },
			{ "<leader>hq", gitsigns.setqflist, desc = "Set [q]uickfix list", buffer = bufnr },
			{ "<leader>ht", group = "[T]oggle", buffer = bufnr },
			{ "<leader>htb", gitsigns.toggle_current_line_blame, desc = "Toggle [b]lame", buffer = bufnr },
			{ "<leader>htw", gitsigns.toggle_word_diff, desc = "Toggle [w]ord diff", buffer = bufnr },
		})

		-- Visual mode mappings
		wk.add({
			{ "<leader>h", group = "[H]unk", mode = "v", buffer = bufnr },
			{ "<leader>hs", function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, desc = "[S]tage hunk", mode = "v", buffer = bufnr },
			{ "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, desc = "[R]eset hunk", mode = "v", buffer = bufnr },
		})
	end
}
