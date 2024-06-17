{pkgs, ...}: let
  neotest = pkgs.vimUtils.buildVimPlugin {
    name = "neotest";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-neotest";
      repo = "neotest";
      rev = "5caac5cc235d495a2382bc2980630ef36ac87032";
      sha256 = "hIlva0jjoI6RPOyKiCvV0H/SvCJTllOtOXc4fkI1LcQ=";
    };
  };

  neotest-java = pkgs.vimUtils.buildVimPlugin {
    name = "neotest-java";
    src = pkgs.fetchFromGitHub {
      owner = "rcasia";
      repo = "neotest-java";
      rev = "54d7af85452ff04ace0cfcdf23457aa7857b027a";
      sha256 = "QCL/SQn4W7zH7U3tvFs903Lgw5dLAsSc4s5MYyU1T+M=";
    };
  };

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
  programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
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
      plugin = neotest-vim-test;
    }
    {
      plugin = nvim-nio;
    }
  ];
}
