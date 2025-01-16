local wk = require("which-key")
local dap = require("dap")
wk.add(
  {
    { "<leader>d",  group = "[D]ebug" },
    { "<leader>dB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Set conditional [B]reakpoint" },
    { "<leader>db", function() dap.toggle_breakpoint() end,                                    desc = "Toggle [B]reakpoint" },
    { "<leader>dc", function() dap.continue() end,                                             desc = "[C]ontinue" },
    { "<leader>di", function() dap.step_into() end,                                            desc = "Step [I]nto" },
    { "<leader>do", function() dap.step_over() end,                                            desc = "Step [O]ver" },
    { "<leader>dq", function() dap.close() end,                                                desc = "[Q]uit/Close dap" },
    { "<leader>du", function() dap.step_out() end,                                             desc = "Step O[u]t" },
  }
)

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
