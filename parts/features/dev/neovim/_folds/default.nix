{pkgs, ...}: {
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.nvim-ufo;
      config = builtins.readFile ./ufo.lua;
      type = "lua";
    }
  ];
}
