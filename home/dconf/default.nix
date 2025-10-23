{
  lib,
  isImpermanent,
  ...
}: {
  home.persistence."/persist" = lib.mkIf isImpermanent {
    directories = [
      ".config/dconf"
    ];
  };
}
