{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = plenary-nvim;
      config = ''
      '';
      type = "lua";
    }
  ];
}
