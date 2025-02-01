{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = render-markdown-nvim;
      config = ''
        require('render-markdown').setup({
          file_types = {'markdown', 'Avante'},
        })
      '';
      type = "lua";
    }
  ];
}
