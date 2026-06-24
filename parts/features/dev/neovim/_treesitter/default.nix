{pkgs, ...}: {
  programs.neovim.extraPackages = [
    pkgs.gcc
    pkgs.tree-sitter
  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      # nvim-treesitter 1.0 (main branch). `require('nvim-treesitter.configs').setup`
      # is gone: highlighting/indentation are enabled per-buffer via the native
      # vim.treesitter API and incremental_selection is reimplemented on top of it.
      # See treesitter.lua. Parsers are provided by nix, so no :TSInstall is needed.
      plugin = nvim-treesitter.withAllGrammars;
      config = builtins.readFile ./treesitter.lua;
      runtime = {
        "after/queries/nix/injections.scm".source = ./queries/nix/injections.scm;
      };
      type = "lua";
    }
    {
      plugin = nvim-treesitter-context; # ip, ap, etc... from treesitter!
      config = ''
      '';
      type = "lua";
    }
    {
      plugin = nvim-treesitter-textobjects; # ip, ap, etc... from treesitter!
      config = ''
      '';
      type = "lua";
    }
  ];
}
