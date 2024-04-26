{ pkgs, ... }:
{

  # Could be vim.extraPackages instead, but keeping this globally installed to easily figure out the f*ed up manual versions in jdtls.lua after an upgrade
  home.packages = [ pkgs.jdt-language-server ];

  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.nvim-jdtls;
      runtime = {
        "ftplugin/java.lua".text = builtins.replaceStrings [ "JDTLS_PATH" ] [ "${pkgs.jdt-language-server}" ] (builtins.readFile ./jdtls.lua);
      };
      type = "lua";
    }
  ];

}
