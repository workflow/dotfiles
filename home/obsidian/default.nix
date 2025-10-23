{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/obsidian"
      "Obsidian"
    ];
  };

  home.packages = [
    pkgs.obsidian
  ];
}
