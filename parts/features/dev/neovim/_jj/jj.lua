-- F3 keybinding to toggle jjui in a floating terminal
local Terminal = require('toggleterm.terminal').Terminal
local jjui_term = Terminal:new({
  cmd = "jjui",
  direction = "float",
  hidden = true,
  on_open = function(term)
    vim.cmd("startinsert!")
    -- Allow ESC to work inside jjui instead of exiting terminal mode
    vim.keymap.set('t', '<Esc>', '<Esc>', { buffer = term.bufnr, noremap = true })
  end,
})

vim.keymap.set('n', '<F3>', function()
  jjui_term:toggle()
end, { desc = "Toggle jjui in floating terminal" })

vim.keymap.set('t', '<F3>', function()
  jjui_term:toggle()
end, { desc = "Toggle jjui in floating terminal" })

