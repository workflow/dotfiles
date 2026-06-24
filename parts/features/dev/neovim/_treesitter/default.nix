{pkgs, ...}: {
  programs.neovim.extraPackages = [
    pkgs.gcc
    pkgs.tree-sitter
  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      # nvim-treesitter 1.0 (main branch) removed `require('nvim-treesitter.configs').setup`
      # entirely. Stick with the legacy v0.9 API for now; it's marked deprecated and
      # will become a hard error in nixpkgs 26.11. Migration TODO: rewrite highlight/indent
      # as FileType autocmds and replace incremental_selection (no drop-in successor).
      plugin = nvim-treesitter-legacy.withAllGrammars;
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
      plugin = nvim-treesitter-textobjects-legacy; # ip, ap, etc... from treesitter!
      config = ''
      '';
      type = "lua";
    }
  ];
}
