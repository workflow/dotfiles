{
  isImpermanent,
  lib,
  pkgs,
  ...
}: let
  bookmarks-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "bookmarks-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "tomasky";
      repo = "bookmarks.nvim";
      rev = "12bf1b32990c49192ff6e0622ede2177ac836f11";
      sha256 = "DWtYdAioIrNLZg3nnkAXDo1MPZDbpA2F/KlKjS8kVls=";
    };
  };
in {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    files = [
      ".bookmarks/bookmarks.nvim"
    ];
  };

  programs.neovim = {
    plugins = [
      {
        plugin = bookmarks-nvim;
        config = ''
          require("bookmarks").setup({
            save_file = vim.fn.expand "$HOME/.bookmarks/bookmarks.nvim",
            on_attach = function(bufnr)
              local bm = require("bookmarks")
              local wk = require("which-key")
              wk.add(
                {
                  { "<leader>m", group = "Book[m]arks" },
                  { "<leader>ma", bm.bookmark_ann, desc = "Toggle [a]nnotation at current line" },
                  { "<leader>mc", bm.bookmark_clean, desc = "Clean all marks in local buffer" },
                  { "<leader>ml", bm.bookmark_list, desc = "Show marked file list in quickfix list" },
                  { "<leader>mm", bm.bookmark_toggle, desc = "Toggle [m]ark at current line" },
                  { "<leader>mn", bm.bookmark_next, desc = "Jump to next mark in local buffer" },
                  { "<leader>mp", bm.bookmark_prev, desc = "Jump to previous mark in local buffer" },
                }
              )
              require('telescope').load_extension('bookmarks')
            end
          })
        '';
        type = "lua";
      }
    ];
  };
}
