{ pkgs, ... }:
{
  programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
    {
      plugin = vim-dadbod; # SQL Fu
    }
    {
      plugin = vim-dadbod-completion;
    }
    {
      plugin = vim-dadbod-ui;
    }
  ];
}
