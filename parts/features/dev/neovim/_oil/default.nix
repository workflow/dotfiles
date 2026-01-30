{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = oil-nvim;
      config = ''
        require('oil').setup({
          default_file_explorer = false,
          delete_to_trash = true,
          skip_confirm_for_simple_edits = true,
          view_options = {
            show_hidden = true,
            natural_order = true,
            is_always_hidden = function(name, _)
              return name == '..' or name == '.git'
            end,
          },
          win_options = {
            wrap = true,
          },
        })

        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      '';
      type = "lua";
    }
  ];
}
