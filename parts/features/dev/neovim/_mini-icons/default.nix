{pkgs, ...}: {
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.mini-icons;
      config = ''
        require('mini.icons').setup()
        require('mini.icons').mock_nvim_web_devicons()
      '';
      type = "lua";
    }
  ];
}
