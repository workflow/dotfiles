{pkgs, ...}: let
  rainbow-csv-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "rainbow-csv-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "cameron-wags";
      repo = "rainbow_csv.nvim";
      rev = "7f3fddfe813641035fac2cdf94c2ff69bb0bf0b9";
      sha256 = "sha256-/XHQd/+sqhVeeMAkcKNvFDKFuFecChrgp56op3KQAhs=";
    };
  };
in {
  programs.neovim.plugins = [
    {
      plugin = rainbow-csv-nvim;
      config = ''
        require('rainbow_csv').setup({})
      '';
      type = "lua";
    }
  ];
}
