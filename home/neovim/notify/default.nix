{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = nvim-notify;
      config = ''
        require('notify').setup()
      '';
      type = "lua";
    }
  ];
}
