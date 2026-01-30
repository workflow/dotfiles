{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = git-conflict-nvim;
      config = ''
        require('git-conflict').setup({})
      '';
      type = "lua";
    }
  ];
}
