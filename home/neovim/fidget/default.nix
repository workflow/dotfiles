# Sidebar notifications for LSP
{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = fidget-nvim;
      config = ''
        require('fidget').setup()
      '';
      type = "lua";
    }
  ];
}
