{pkgs, ...}: {
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.mini-icons;
      config = ''
      '';
      type = "lua";
    }
  ];
}
