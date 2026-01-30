{...}: {
  flake.modules.homeManager.k9s = {
    pkgs,
    lib,
    ...
  }: {
    programs.k9s = {
      enable = true;
      package = pkgs.unstable.k9s;

      skins = {
        gruvbox-dark = ./_skins/gruvbox-dark.yaml;
        gruvbox-light = ./_skins/gruvbox-light.yaml;
      };

      settings = {
        k9s = {
          ui = {
            skin = lib.mkDefault "gruvbox-dark";
          };
        };
      };
    };
  };
}
