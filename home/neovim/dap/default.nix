{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = nvim-dap; # Debug Adapter Protocol
      config = builtins.readFile ./dap.lua;
      type = "lua";
    }
    {
      plugin = nvim-dap-ui; # DAP UI
      config = builtins.readFile ./dap-ui.lua;
      type = "lua";
    }
    {
      plugin = nvim-dap-virtual-text; # Virtual text showing values using Treesitter
      config = ''
        require("nvim-dap-virtual-text").setup()
      '';
      type = "lua";
    }
    # JavaScript/TypeScript DAP adapter
    {
      plugin = nvim-dap-vscode-js;
    }
  ];
}
