return {
  name = "update secrets",
  builder = function()
    return {
      cmd = { "nix" },
      args = { "flake lock --update-input secrets" },
    }
  end,
  condition = {
    dir = "~/code/nixos-config",
  },
}
