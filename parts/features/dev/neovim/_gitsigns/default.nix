{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = gitsigns-nvim;
      config = builtins.readFile ./gitsigns.lua;
      type = "lua";
    }
  ];
}
