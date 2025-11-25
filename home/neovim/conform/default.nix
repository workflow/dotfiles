{pkgs, ...}: {
  programs.neovim.extraPackages = with pkgs; [
    eslint
  ];
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = conform-nvim;
      config = builtins.readFile ./conform.lua;
      type = "lua";
    }
  ];
}
