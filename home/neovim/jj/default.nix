{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = toggleterm-nvim;
      config = builtins.readFile ./jj.lua;
      type = "lua";
    }
  ];
}

