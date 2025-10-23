{
  isImpermanent,
  lib,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/github-copilot"
    ];
  };
  programs.neovim.plugins = with pkgs.vimPlugins; [
    copilot-lsp
    {
      plugin = copilot-lua;
      config = builtins.readFile ./copilot.lua;
      type = "lua";
    }
  ];
}
