{ pkgs, ... }:
{

  programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
    {
      plugin = nvim-treesitter.withAllGrammars;
      config = builtins.readFile ./treesitter.lua;
      type = "lua";
    }
    {
      plugin = nvim-treesitter-textobjects; # ip, ap, etc... from treesitter!
      config = ''
        '';
      type = "lua";
    }
  ];

}
