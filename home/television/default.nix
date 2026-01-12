{
  isImpermanent,
  lib,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/television/cable"
    ];
  };

  programs.television = {
    enable = true;
  };
  programs.nix-search-tv = {
    enable = true;
  };
}
