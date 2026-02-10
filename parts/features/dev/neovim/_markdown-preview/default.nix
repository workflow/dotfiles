{pkgs, ...}: let
  live-server-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "live-server-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "selimacerbas";
      repo = "live-server.nvim";
      rev = "d6a253569ebb813c622f56971f55f56d044f6ab5";
      sha256 = "pUg1sTdnngZ5XzPRY8LZlbkfzXt0c0ObSrlGF6V7RLU=";
    };
  };
  mermaid-preview-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "mermaid-preview-nvim";
    dependencies = [live-server-nvim];
    src = pkgs.fetchFromGitHub {
      owner = "selimacerbas";
      repo = "markdown-preview.nvim";
      rev = "a3ad2b3883a273890eb8901563f4cc6a0becf58b";
      sha256 = "cbDWzd06ZmQhgHs8obVzgQUicnWCRBVYmTaAfISZILA=";
    };
  };
in {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = markdown-preview-nvim;
      config = ''
        local wk = require("which-key")
        wk.add({
          { "<leader>p", "<Plug>MarkdownPreviewToggle", desc = "Toggle Markdown [P]review" },
        })
      '';
      type = "lua";
    }
    live-server-nvim
    {
      plugin = mermaid-preview-nvim;
      config = ''
        require("markdown_preview").setup({})
        local wk = require("which-key")
        wk.add({
          { "<leader>P", ":MarkdownPreview<CR>", desc = "Toggle Mermaid [P]review" },
        })
      '';
      type = "lua";
    }
  ];
}
