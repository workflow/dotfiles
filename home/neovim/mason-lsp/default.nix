{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = mason-nvim; # Automatically install LSP servers
      config = builtins.readFile ./mason.lua;
      runtime = {
        "lua/shared_lsp_config.lua".source = ./shared_lsp_config.lua;
      };
      type = "lua";
    }
    {
      plugin = mason-lspconfig-nvim; # Automatically install LSP servers
    }
    {
      plugin = mason-nvim-dap-nvim; # Automatically configure DAP adapters
    }
  ];
}
