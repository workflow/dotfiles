{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = trouble-nvim;
      config = builtins.readFile ./trouble.lua;
      type = "lua";
    }
  ];
}
