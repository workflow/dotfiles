{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = lspsaga-nvim;
      config = ''
        require('lspsaga').setup({
          lightbulb = {
            enable = true,
            sign = false, -- disable the sign in signcolumn, which creates bouncy shit
          },
        })
      '';
      type = "lua";
    }
  ];
}
