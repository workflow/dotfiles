{ pkgs, ... }:
{
  programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
    {
      plugin = vim-dadbod; # SQL Fu
      config = ''
        vim.g.db_ui_use_nerd_fonts = 1
      '';
      type = "lua";
    }
    {
      plugin = vim-dadbod-completion;
    }
    {
      plugin = vim-dadbod-ui;
    }
  ];
}
