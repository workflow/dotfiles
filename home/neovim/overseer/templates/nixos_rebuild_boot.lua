return {
  name = "nixos rebuild boot",
  builder = function()
    return {
      cmd = { "nh" },
      args = { "os", "boot" },
    }
  end,
  condition = {
    dir = "~/code/nixos-config",
  },
}
