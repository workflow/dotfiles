{pkgs, ...}: let
  jj-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "jj-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "NicolasGB";
      repo = "jj.nvim";
      rev = "v0.4.0";
      sha256 = "sha256-BY4wDMMQUdu6DHfMqP4lpHQdHhS+yL6+CUiKQJFJY2Q=";
    };
  };
in {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = toggleterm-nvim;
      config = builtins.readFile ./jj.lua;
      type = "lua";
    }
    {
      plugin = jj-nvim;
      config = ''
        require("jj").setup({
          diff = {
            backend = "diffview",
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
        })
      '';
      type = "lua";
    }
  ];
}
