# Status line for neovim
{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = lualine-nvim;
      config = ''
        require('lualine').setup({
          options = {
            theme = 'gruvbox',
          },
          extensions = {
            'fugitive',
            'mason',
            'nvim-tree',
            'oil',
            'overseer',
            'quickfix',
            'toggleterm',
            'trouble',
          },
          sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'fugitive_branch', 'diagnostics'},
            lualine_c = {'filename'},
            lualine_x = {
              {
                require("noice").api.status.message.get_hl,
                cond = require("noice").api.status.message.has,
              },
              {
                require("noice").api.status.command.get,
                cond = require("noice").api.status.command.has,
                color = { fg = "#ff9e64" },
              },
              {
                require("noice").api.status.mode.get,
                cond = require("noice").api.status.mode.has,
                color = { fg = "#ff9e64" },
              },
              {
                require("noice").api.status.search.get,
                cond = require("noice").api.status.search.has,
                color = { fg = "#ff9e64" },
              },
              'overseer',
              'encoding',
              'fileformat',
              'filetype'
            },
            lualine_y = {'progress'},
            lualine_z = {'location'}
          },
        })
      '';
      type = "lua";
    }
  ];
}
