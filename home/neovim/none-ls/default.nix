{pkgs, ...}: let
  none-ls-extras = pkgs.vimUtils.buildVimPlugin {
    name = "none-ls-extras";
    doCheck = false;
    src = pkgs.fetchFromGitHub {
      owner = "nvimtools";
      repo = "none-ls-extras.nvim";
      rev = "924fe88a9983c7d90dbb31fc4e3129a583ea0a90";
      sha256 = "sha256-OJHg2+h3zvlK7LJ8kY6f7et0w6emnxfcDbjD1YyWRTw=";
    };
  };
in {
  programs.neovim.extraPackages = with pkgs; [
    eslint
  ];
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = none-ls-nvim; # Automatically install LSP servers
      config = builtins.readFile ./none-ls.lua;
      type = "lua";
    }
    {
      plugin = none-ls-extras;
    }
  ];
}
