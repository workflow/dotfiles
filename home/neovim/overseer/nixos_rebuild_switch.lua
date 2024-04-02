return {
  name = "nixos rebuild switch",
  builder = function()
    return {
      cmd = { "nixos" },
      args = { "s" },
    }
  end,
  condition = {
    dir = "~/code/nixos-config",
  },
}
