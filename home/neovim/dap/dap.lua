local wk = require("which-key")
local dap = require("dap")
wk.add(
  {
    { "<leader>d",  group = "[D]ebug" },
    { "<leader>dB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Set conditional [B]reakpoint" },
    { "<leader>db", function() dap.toggle_breakpoint() end,                                    desc = "Toggle [B]reakpoint" },
    { "<leader>dc", function() dap.continue() end,                                             desc = "[C]ontinue" },
    { "<F5>",       function() dap.continue() end,                                             desc = "[C]ontinue" },
    { "<leader>di", function() dap.step_into() end,                                            desc = "Step [I]nto" },
    { "<F1>",       function() dap.step_into() end,                                            desc = "Step [I]nto" },
    { "<leader>do", function() dap.step_over() end,                                            desc = "Step [O]ver" },
    { "<F2>",       function() dap.step_over() end,                                            desc = "Step [O]ver" },
    { "<leader>dq", function() dap.close() end,                                                desc = "[Q]uit/Close dap" },
    { "<F4>",       function() dap.close() end,                                                desc = "[Q]uit/Close dap" },
    { "<leader>dr", function() dap.repl.open() end,                                            desc = "Open [R]epl" },
    { "<leader>du", function() dap.step_out() end,                                             desc = "Step O[u]t" },
    { "<F3>",       function() dap.step_out() end,                                             desc = "Step O[u]t" },
  }
)

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
