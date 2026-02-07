vim.keymap.set('v', '<leader>y', function()
  local file = vim.fn.expand('%:p')
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  local relative_path
  if git_root and vim.fn.isdirectory(git_root) == 1 then
    relative_path = file:sub(#git_root + 2)
  else
    relative_path = vim.fn.expand('%:.')
  end
  local start_line = vim.fn.line('v')
  local end_line = vim.fn.line('.')
  local line_part
  if start_line == end_line then
    line_part = tostring(start_line)
  else
    line_part = math.min(start_line, end_line) .. '-' .. math.max(start_line, end_line)
  end
  local result = relative_path .. ':' .. line_part
  vim.fn.setreg('+', result)
  vim.notify('Copied: ' .. result)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
end, { desc = '[Y]ank file:line to clipboard' })
