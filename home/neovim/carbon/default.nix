{pkgs, ...}: let
  carbon-now = pkgs.vimUtils.buildVimPlugin {
    name = "carbon-now";
    src = pkgs.fetchFromGitHub {
      owner = "ellisonleao";
      repo = "carbon-now.nvim";
      rev = "4524d2b347830257bb9357d45c4f934960058476";
      sha256 = "id9KSrv683eb03ZB9VZ+ERBKuAlWbypjx0kEzCeiL0c=";
    };
  };
in {
  programs.neovim.plugins = [
    {
      plugin = carbon-now;
      config = ''
        require('carbon-now').setup({
           options = {
              bg = "purple",
              drop_shadow_blur = "68px",
              drop_shadow = false,
              drop_shadow_offset_y = "20px",
              font_family = "Fira Code",
              font_size = "18px",
              line_height = "133%",
              line_numbers = true,
              theme = "one-dark",
              titlebar = "Made with carbon-now.nvim",
              watermark = false,
              window_theme = "sharp",
              padding_horizontal = "5px",
              padding_vertical = "5px",
            },
        })

        vim.keymap.set("v", "<leader>s", ":CarbonNow<CR>", { silent = true })
        local wk = require("which-key")
        wk.add(
          {
            { "<leader>s", desc = "[S]creenshot", mode = "v" },
          }
        )
      '';
      type = "lua";
    }
  ];
}
