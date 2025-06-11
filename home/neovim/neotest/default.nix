{pkgs, ...}: {
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
      plugin = nvim-nio;
    }
  ];
}
