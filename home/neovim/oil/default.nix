{ pkgs, ... }:
{

  programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
    {
      plugin = oil-nvim;
      config = ''
        require('oil').setup({
          default_file_explorer = false,
        })

        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      '';
      type = "lua";
    }
  ];

}
