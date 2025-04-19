{
  lib,
  isImpermanent,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/farlion/" = lib.mkIf isImpermanent {
    directories = [
      ".config/obsidian"
      "Obsidian"
    ];
  };

  home.packages = [
    pkgs.obsidian
  ];
}
