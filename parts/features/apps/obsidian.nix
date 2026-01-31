{...}: {
  flake.modules.homeManager.obsidian = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/obsidian"
        "Obsidian"
      ];
    };

    home.packages = [
      pkgs.obsidian
    ];
  };
}
