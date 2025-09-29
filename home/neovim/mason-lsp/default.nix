{pkgs, ...}: {
  programs.neovim = {
    extraLuaConfig = ''
      -- LSP diagnostics: show inline virtual text
      vim.diagnostic.config({
        virtual_text = {
          spacing = 2,
          prefix = "●",
        },
        signs = true,          -- keep signs in the gutter
        underline = true,      -- underline offending code
        update_in_insert = false, -- reduce noise while typing
        severity_sort = true,  -- sort diagnostics by severity
        float = {
          border = "rounded",
          source = "if_many",
        },
      })
    '';

    plugins = with pkgs.vimPlugins; [
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
  };
}
