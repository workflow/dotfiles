{ pkgs, ... }:
let
  none-ls = pkgs.vimUtils.buildVimPlugin {
    name = "none-ls";
    src = pkgs.fetchFromGitHub {
      owner = "nvimtools";
      repo = "none-ls.nvim";
      rev = "10c976d633862b9fe16171f5f5f17732bc54e19f";
      sha256 = "kV2+ryMoHaGvfh9DDnS/scmPzeicmxI09WQH2hd2e/c=";
    };
  };
in
{
  programs.neovim.plugins =  [
    {
      plugin = none-ls; # Automatically install LSP servers
      config = builtins.readFile ./none-ls.lua;
      type = "lua";
    }
  ];
}
