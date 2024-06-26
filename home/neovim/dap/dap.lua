local wk = require("which-key")
local dap = require("dap")
wk.register({
  d = {
    name = "[D]ebug",
    b = { function() dap.toggle_breakpoint() end, "Toggle [B]reakpoint" },
    B = { function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, "Set conditional [B]reakpoint" },
    c = { function() dap.continue() end, "[C]ontinue" },
    i = { function() dap.step_into() end, "Step [I]nto" },
    o = { function() dap.step_over() end, "Step [O]ver" },
    u = { function() dap.step_out() end, "Step O[u]t" },
    q = { function() dap.close() end, "[Q]uit/Close dap" },
  },
}, { prefix = "<leader>" })

dap.adapters.lldb = {
  type = "executable",
  command = "/usr/bin/lldb-vscode",
  name = "lldb",
}

dap.configurations.rust = {
  {
    name = "hello-world",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.getcwd() .. "/target/debug/hello-world"
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
  {
    name = "hello-dap",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.getcwd() .. "/target/debug/hello-dap"
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}
