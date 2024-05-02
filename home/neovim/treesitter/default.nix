{ pkgs, ... }:
{

  programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
    {
      plugin = nvim-treesitter.withAllGrammars;
      config = ''
        -- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
        vim.defer_fn(function()
          require('nvim-treesitter.configs').setup {
            auto_install = false,
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
              enable = true,
              keymaps = {
                init_selection = '<c-s>',
                node_incremental = '<c-s>',
                node_decremental = '<c-M-s>',
              },
            },
          }
        end, 0)
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
