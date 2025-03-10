{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = obsidian-nvim;
      config = ''
        require("obsidian").setup({
          workspaces = {
            {
              name = "main",
              path = "~/Obsidian",
            }
          },
        })
      '';
      type = "lua";
    }
  ];
}
