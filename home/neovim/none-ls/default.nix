{
  lib,
  pkgs,
  ...
}: let
  none-ls = pkgs.vimUtils.buildVimPlugin {
    name = "none-ls";
    src = pkgs.fetchFromGitHub {
      owner = "nvimtools";
      repo = "none-ls.nvim";
      rev = "a117163db44c256d53c3be8717f3e1a2a28e6299";
      sha256 = "KP/mS6HfVbPA5javQdj/x8qnYYk0G6oT0RZaPTAPseM=";
    };
  };
  none-ls-extras = pkgs.vimUtils.buildVimPlugin {
    name = "none-ls-extras";
    src = pkgs.fetchFromGitHub {
      owner = "nvimtools";
      repo = "none-ls-extras.nvim";
      rev = "1214d729e3408470a7b7a428415a395e5389c13c";
      sha256 = "5wQHdV2lmxMegN/BPg+qfGTNGv/T9u+hy4Yaj41PchI=";
    };
  };
in {
  programs.neovim.plugins = [
    {
      plugin = none-ls; # Automatically install LSP servers
      config = builtins.readFile ./none-ls.lua;
      type = "lua";
    }
    {
      plugin = none-ls-extras;
    }
  ];
}
