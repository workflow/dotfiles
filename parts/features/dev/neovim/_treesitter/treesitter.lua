-- Treesitter configuration for the nvim-treesitter 1.0 (main branch) API.
--
-- The main branch removed `require('nvim-treesitter.configs').setup`. Highlighting
-- and indentation are now enabled per-buffer via Neovim's native treesitter API,
-- and incremental selection (dropped upstream with no successor) is reimplemented
-- here on top of `vim.treesitter`.

local MAX_LINES = 5000

local disabled_filetypes = {
  csv = true, -- In favor of rainbow-csv-nvim
}

local function treesitter_unwanted(bufnr)
  return disabled_filetypes[vim.bo[bufnr].filetype]
    or vim.api.nvim_buf_line_count(bufnr) > MAX_LINES
end

local function enable_treesitter(bufnr)
  if treesitter_unwanted(bufnr) then
    return
  end

  -- vim.treesitter.start errors when no parser exists for the buffer's language;
  -- those filetypes simply fall back to regex syntax.
  if pcall(vim.treesitter.start, bufnr) then
    vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable treesitter highlighting and indentation',
  callback = function(args)
    enable_treesitter(args.buf)
  end,
})

-- Incremental selection -------------------------------------------------------
-- Reimplements the `incremental_selection` module removed from nvim-treesitter
-- 1.0 by climbing the syntax tree to grow/shrink the visual selection. Each
-- buffer keeps a stack of the nodes it has expanded through so it can shrink back.

local selection_stack = {} -- bufnr -> TSNode[]
local select_node, next_larger_ancestor, ranges_equal -- defined below

local function init_selection()
  local bufnr = vim.api.nvim_get_current_buf()
  local node = vim.treesitter.get_node()
  if not node then
    return
  end
  selection_stack[bufnr] = { node }
  select_node(node)
end

local function node_incremental()
  local bufnr = vim.api.nvim_get_current_buf()
  local stack = selection_stack[bufnr]
  if not stack or #stack == 0 then
    return init_selection()
  end

  local node = next_larger_ancestor(stack[#stack])
  if node then
    table.insert(stack, node)
  else
    node = stack[#stack]
  end
  select_node(node)
end

local function node_decremental()
  local bufnr = vim.api.nvim_get_current_buf()
  local stack = selection_stack[bufnr]
  if not stack or #stack <= 1 then
    return
  end
  table.remove(stack)
  select_node(stack[#stack])
end

-- Climb to the nearest ancestor whose range is strictly larger than `node`'s, so
-- repeated expansion never gets stuck on nested nodes that share a range.
function next_larger_ancestor(node)
  local parent = node:parent()
  while parent and ranges_equal(parent, node) do
    parent = parent:parent()
  end
  return parent
end

function ranges_equal(a, b)
  local a1, a2, a3, a4 = a:range()
  local b1, b2, b3, b4 = b:range()
  return a1 == b1 and a2 == b2 and a3 == b3 and a4 == b4
end

-- Drive a charwise visual selection over `node`'s range. Treesitter ranges are
-- 0-indexed with an exclusive end column; nvim_win_set_cursor wants 0-indexed
-- columns too, so the end character sits at `ecol - 1`.
function select_node(node)
  local srow, scol, erow, ecol = node:range()
  if ecol == 0 then
    -- Range ends at column 0 of erow: select through the previous line's end.
    erow = erow - 1
    ecol = math.max(#vim.fn.getline(erow + 1), 1)
  end

  if vim.fn.mode():match('[vV\22]') then
    vim.cmd('normal! \27') -- leave any active selection before reselecting
  end
  vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
  vim.cmd('normal! v')
  vim.api.nvim_win_set_cursor(0, { erow + 1, ecol - 1 })
end

vim.keymap.set('n', '<c-s>', init_selection, { desc = 'Treesitter: Init selection' })
vim.keymap.set('x', '<c-s>', node_incremental, { desc = 'Treesitter: Expand selection' })
vim.keymap.set('x', '<c-M-s>', node_decremental, { desc = 'Treesitter: Shrink selection' })
vim.keymap.set('x', '+', node_incremental, { desc = 'Treesitter: Expand selection' })
vim.keymap.set('x', '_', node_decremental, { desc = 'Treesitter: Shrink selection' })

local wk = require('which-key')
wk.add({
  { '<c-s>', desc = 'Treesitter: Init/Expand selection', mode = { 'n', 'x' } },
  { '<c-M-s>', desc = 'Treesitter: Shrink selection', mode = 'x' },
  { '+', desc = 'Treesitter: Expand selection', mode = 'x' },
  { '_', desc = 'Treesitter: Shrink selection', mode = 'x' },
})
