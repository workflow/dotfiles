vim.g.copilot_nes_debounce = 500

require("copilot").setup({
	nes = {
		enabled = true,
		auto_trigger = false,
		keymap = {
			-- When a NES suggestion exists, accept it and jump to the changed location.
			-- If no suggestion exists, the keypress is passed through.
			accept_and_goto = "p",
			accept = false,
			dismiss = "<Esc>",
		},
	},
})
