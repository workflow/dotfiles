return {
  name = "nixos rebuild switch",
  builder = function()
    return {
      cmd = { "nh" },
      args = { "os", "switch" },
    }
  end,
  condition = {
    dir = "~/code/nixos-config",
  },
}
