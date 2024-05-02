{ pkgs, ... }:
{

  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = nvim-dap; # Debug Adapter Protocol
      config = builtins.readFile ./dap.lua;
      type = "lua";
    }
    {
      plugin = nvim-dap-ui; # DAP UI 
      config = ''
        '';
      type = "lua";
    }
  ];

}
