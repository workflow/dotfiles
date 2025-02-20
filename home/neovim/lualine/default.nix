# Status line for neovim
{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = lualine-nvim;
      config = ''
        require('lualine').setup {
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
          }
        }
      '';
      type = "lua";
    }
  ];
}
