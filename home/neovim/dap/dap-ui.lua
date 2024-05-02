local wk = require("which-key")
local dap, dapui = require("dap"), require("dapui")
dapui.setup({
  wk.register({
    d = {
      t = { require('dapui').toggle, "[T]oggle UI" },
    },
  }, { prefix = "<leader>" })
})

-- Events to auto-open/close the UI
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end
