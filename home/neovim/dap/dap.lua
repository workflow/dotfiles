local wk = require("which-key")
local dap = require("dap")
wk.add(
  {
    { "<leader>d",  group = "[D]ebug" },
    { "<leader>dB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Set conditional [B]reakpoint" },
    { "<leader>db", function() dap.toggle_breakpoint() end,                                    desc = "Toggle [B]reakpoint" },
    { "<leader>dc", function() dap.continue() end,                                             desc = "[C]ontinue" },
    { "<F5>",       function() dap.continue() end,                                             desc = "Continue" },
    { "<leader>di", function() dap.step_into() end,                                            desc = "Step [I]nto" },
    { "<F6>",       function() dap.step_into() end,                                            desc = "Step Into" },
    { "<leader>do", function() dap.step_over() end,                                            desc = "Step [O]ver" },
    { "<F7>",       function() dap.step_over() end,                                            desc = "Step Over" },
    { "<leader>dq", function() dap.close() end,                                                desc = "[Q]uit/Close dap" },
    { "<F4>",       function() dap.close() end,                                                desc = "Quit/Close dap" },
    { "<leader>dr", function() dap.repl.open() end,                                            desc = "Open [R]epl" },
    { "<leader>du", function() dap.step_out() end,                                             desc = "Step O[u]t" },
    { "<F8>",       function() dap.step_out() end,                                             desc = "Step Out" },
  }
)

-- Fix color highlighting for stopped DAP line
-- See https://github.com/mfussenegger/nvim-dap/discussions/355#discussioncomment-8389225
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  desc = "Prevent colorscheme clearing self-defined DAP marker colors",
  callback = function()
    -- Reuse current SignColumn background (except for DapStoppedLine)
    local sign_column_hl = vim.api.nvim_get_hl(0, { name = 'SignColumn' })
    -- if bg or ctermbg aren't found, use bg = 'bg' (which means current Normal) and ctermbg = 'Black'
    -- convert to 6 digit hex value starting with #
    local sign_column_bg = (sign_column_hl.bg ~= nil) and ('#%06x'):format(sign_column_hl.bg) or 'bg'
    local sign_column_ctermbg = (sign_column_hl.ctermbg ~= nil) and sign_column_hl.ctermbg or 'Black'

    vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#00ff00', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
    vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#2e4d3d', ctermbg = 'Green' })
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#c23127', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
    vim.api.nvim_set_hl(0, 'DapBreakpointRejected',
      { fg = '#888ca6', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
    vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef', bg = sign_column_bg, ctermbg = sign_column_ctermbg })

    vim.fn.sign_define('DapStopped', {
      text   = '→',
      texthl = 'DapStopped',
      linehl = 'DapStoppedLine',
      numhl  = 'DapStoppedLine',
    })
  end
})

dap.adapters.codelldb = {
  type = "executable",
  command = "codelldb",
};

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
