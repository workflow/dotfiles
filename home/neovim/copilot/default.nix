{
  isImpermanent,
  lib,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion" = lib.mkIf isImpermanent {
    directories = [
      ".config/github-copilot"
    ];
  };
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = copilot-vim;
    }
  ];
}
