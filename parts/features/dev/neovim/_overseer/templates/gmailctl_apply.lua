return {
  name = "gmailctl apply",
  builder = function()
    return {
      cmd = { "gmailctl" },
      args = { "apply" },
    }
  end,
  condition = {
    filetype = { "jsonnet" },
  },
}
