{...}: {
  programs.neovim.extraLuaConfig = builtins.readFile ./yank-file-line.lua;
}
