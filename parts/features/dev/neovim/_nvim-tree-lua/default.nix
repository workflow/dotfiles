{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = nvim-tree-lua;
      config = builtins.readFile ./nvim-tree.lua;
      type = "lua";
    }
  ];
}
