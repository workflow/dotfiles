{
  isImpermanent,
  lib,
  pkgs,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".mullvad"
    ];
  };

  home.packages = [
    pkgs.mullvad-browser
  ];
}
