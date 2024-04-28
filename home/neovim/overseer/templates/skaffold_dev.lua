return {
  name = "skaffold dev",
  builder = function()
    return {
      cmd = { "skaffold" },
      args = { "dev" },
    }
  end,
  condition = {
    filetype = "yaml",
  },
}
