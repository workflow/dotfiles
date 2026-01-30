{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = nui-nvim;
      config = ''
      '';
      type = "lua";
    }
  ];
}
