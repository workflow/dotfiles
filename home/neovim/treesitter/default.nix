{pkgs, ...}: {
  programs.neovim.extraPackages = [pkgs.unstable.gcc];

  programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
    # TODO: This is Neovim-Native after 0.10, see https://github.com/nvim-treesitter/playground
    {
      plugin = playground;
      config = ''
      '';
      type = "lua";
    }
    {
      plugin = nvim-treesitter.withAllGrammars;
      config = builtins.readFile ./treesitter.lua;
      runtime = {
        "after/queries/nix/injections.scm".source = ./queries/nix/injections.scm;
      };
      type = "lua";
    }
    {
      plugin = nvim-treesitter-context; # ip, ap, etc... from treesitter!
      config = ''
      '';
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
