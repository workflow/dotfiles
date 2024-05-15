{ pkgs, ... }:
{

  programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = nvim-cmp; # Autocompletion 
        config = builtins.readFile ./cmp.lua;
        type = "lua";
      }
      {
        plugin = cmp_luasnip; # Autocompletion for luasnip
      }
      {
        plugin = cmp-nvim-lsp; # Autocompletion Additions
      }
      {
        plugin = cmp-path; # Path completions
      }
      {
        plugin = cmp-buffer; # Buffer completions
      }
      {
        plugin = lspkind-nvim; # VSCode-like pictograms for LSP completions
      }
  ];

}
