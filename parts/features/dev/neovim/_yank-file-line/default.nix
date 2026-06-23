{...}: {
  programs.neovim.initLua = builtins.readFile ./yank-file-line.lua;
}
