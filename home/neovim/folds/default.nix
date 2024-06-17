{pkgs, ...}: {
  programs.neovim.plugins = [
    {
      plugin = pkgs.unstable.vimPlugins.nvim-ufo;
      config = builtins.readFile ./ufo.lua;
      type = "lua";
    }
  ];
}
