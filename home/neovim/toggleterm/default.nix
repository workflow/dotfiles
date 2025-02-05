{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = toggleterm-nvim;
      config = ''
        require("toggleterm").setup({
          open_mapping = [[<c-\>]],
          direction = 'float',
        })
      '';
      type = "lua";
    }
  ];
}
