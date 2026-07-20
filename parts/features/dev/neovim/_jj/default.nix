{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = toggleterm-nvim;
      config = builtins.readFile ./jj.lua;
      type = "lua";
    }
    {
      # v0.7.1 (:J resolve, fugitive-style :Jedit/:Jread, Jbrowse); stable still ships 0.6.0
      plugin = pkgs.unstable.vimPlugins.jj-nvim;
      config = ''
        require("jj").setup({
          diff = {
            backend = "diffview",
          },
          editor = {
            auto_insert = true,
          },
          cmd = {
            resolve_strategies = {
              { name = "Mergiraf", args = { "--tool", "mergiraf" }, external = true },
            },
          },
        })

        local wk = require("which-key")
        local cmd = require("jj.cmd")
        wk.add({
          { "<leader>j", group = "[J]ujutsu" },
          { "<leader>jl", cmd.log, desc = "[L]og" },
          { "<leader>js", cmd.status, desc = "[S]tatus" },
          { "<leader>jc", cmd.commit, desc = "[C]ommit" },
          { "<leader>jd", cmd.describe, desc = "[D]escribe" },
          { "<leader>jn", function() cmd.new({ show_log = true }) end, desc = "[N]ew change" },
          { "<leader>ju", cmd.undo, desc = "[U]ndo" },
          -- Bypass jj.nvim's push handler to use our custom jj push alias
          { "<leader>jp", function() require("jj.ui.terminal").run("jj push") end, desc = "[P]ush" },
          { "<leader>jr", cmd.redo, desc = "[R]edo" },
          { "<leader>jb", "<cmd>Jbrowse<cr>", desc = "[B]rowse file on forge" },
          { "<leader>jx", "<cmd>J resolve<cr>", desc = "Resolve conflicts" },
          { "<leader>je", ":Jedit<Space>", desc = "[E]dit file at revision", silent = false },
        })

        wk.add({
          { "<leader>j", group = "[J]ujutsu", mode = "v" },
          { "<leader>jb", ":Jbrowse<CR>", desc = "[B]rowse selection on forge", mode = "v" },
        })
      '';
      type = "lua";
    }
  ];
}
