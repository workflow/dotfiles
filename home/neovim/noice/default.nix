{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = noice-nvim;
      config = builtins.readFile ./noice.lua;
      type = "lua";
    }
  ];
}
