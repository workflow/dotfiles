{
  pkgs,
  lib,
  ...
}: {
  programs.k9s = {
    enable = true;
    package = pkgs.unstable.k9s;

    skins = {
      gruvbox-dark = ./gruvbox-dark.yaml;
      gruvbox-light = ./gruvbox-light.yaml;
    };

    settings = {
      k9s = {
        ui = {
          # Default to gruvbox-dark, override in light specialisation
          skin = lib.mkDefault "gruvbox-dark";
        };
      };
    };
  };
}
