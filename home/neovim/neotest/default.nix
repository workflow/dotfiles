{pkgs, ...}: let
  neotest-vim-test = pkgs.vimUtils.buildVimPlugin {
    name = "neotest-vim-test";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-neotest";
      repo = "neotest-vim-test";
      rev = "75c4228882ae4883b11bfce9b8383e637eb44192";
      sha256 = "fFm5Yt2Sus5jLSapHUtLlDkBWPLLKfWsj2NSXD8NPYo=";
    };
  };
in {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = FixCursorHold-nvim;
    }
    {
      plugin = neotest;
      config = builtins.readFile ./neotest.lua;
      type = "lua";
    }
    {
      plugin = neotest-java;
    }
    {
      plugin = neotest-rust;
    }
    {
      plugin = neotest-vim-test;
    }
    {
      plugin = nvim-nio;
    }
  ];
}
