vim.keymap.set('v', '<leader>y', function()
  local file = vim.fn.expand('%:p')
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  local relative_path
  if git_root and vim.fn.isdirectory(git_root) == 1 then
    relative_path = file:sub(#git_root + 2)
  else
    relative_path = vim.fn.expand('%:.')
  end
  local line = vim.fn.line('.')
  local result = relative_path .. ':' .. line
  vim.fn.setreg('+', result)
  vim.notify('Copied: ' .. result)
end, { desc = '[Y]ank file:line to clipboard' })
