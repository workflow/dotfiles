{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = lspsaga-nvim;
      config = ''
        require('lspsaga').setup({})
      '';
      type = "lua";
    }
  ];
}
