{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = vim-fugitive;
      config = builtins.readFile ./fugitive.lua;
      type = "lua";
    }
    vim-rhubarb # github bindings for fugitive
  ];
}
