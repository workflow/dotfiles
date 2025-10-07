{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = comment-nvim; # Commenting with gc
      config = ''
        require('Comment').setup()
      '';
      type = "lua";
    }
  ];
}
