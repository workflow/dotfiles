{ inputs, pkgs, ... }:
{
  programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
    {
      plugin = mason-nvim; # Automatically install LSP servers
      config = builtins.replaceStrings [ "LSP_PATH" ] [ "${inputs.nil.packages.x86_64-linux.default}/bin/nil" ] (builtins.readFile ./mason.lua);
      runtime = {
        "lua/shared_lsp_config.lua".source = ./shared_lsp_config.lua;
      };
      type = "lua";
    }
    {
      plugin = mason-lspconfig-nvim; # Automatically install LSP servers
    }
  ];
}
