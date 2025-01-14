{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = ChatGPT-nvim;
      config = builtins.readFile ./chatgpt-nvim.lua;
      type = "lua";
    }
  ];
}
