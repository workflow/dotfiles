{pkgs, ...}: let
  mason-nvim-dap = pkgs.vimUtils.buildVimPlugin {
    name = "mason-nvim-dap";
    src = pkgs.fetchFromGitHub {
      owner = "jay-babu";
      repo = "mason-nvim-dap.nvim";
      rev = "67210c0e775adec55de9826b038e8b62de554afc";
      sha256 = "KhTAomLm57MWWNvLaOeaMGGHJK7uLiNBY0XCyQ1TLSY=";
    };
  };
in {
  # home.packages = [pkgs.nodejs]; # Pyright and other LSPs need a global npm :(
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
      plugin = mason-nvim-dap; # Automatically install LSP servers
    }
  ];
}
