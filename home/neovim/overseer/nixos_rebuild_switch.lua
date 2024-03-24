return {
  name = "nixos rebuild switch",
  builder = function()
    return {
      cmd = { "nixos" },
      args = { "s" },
    }
  end,
  condition = {
    filetype = { "nix" },
  },
}
