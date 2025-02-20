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
            'toggleterm',
            'overseer',
            'trouble',
          },
          sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {'filename'},
            lualine_w = {'overseer'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
          },
        })
      '';
      type = "lua";
    }
  ];
}
