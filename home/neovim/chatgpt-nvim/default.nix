{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
    {
      plugin = ChatGPT-nvim;
      config = builtins.readFile ./chatgpt-nvim.lua;
      type = "lua";
    }
  ];
}
