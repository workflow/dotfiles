{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = diffview-nvim;
      config = builtins.readFile ./diffview-nvim.lua;
      type = "lua";
    }
  ];
}
