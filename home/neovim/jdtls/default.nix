{ pkgs, ... }:
{

  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.nvim-jdtls;
      runtime = {
        "ftplugin/java.lua".source = ./jdtls.lua;
      };
      type = "lua";
    }
  ];

}
